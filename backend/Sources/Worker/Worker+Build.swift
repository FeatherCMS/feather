import Environment
import FeatherGeneratedSES
import FeatherMail
import FeatherMailSES
import Infrastructure
import Jobs
import JobsPostgres
import Logging
import NanoID
import FeatherDatabasePostgres
import NIOSSL
import PostgresMigrations
import PostgresNIO
import ServiceLifecycle
import SotoCore
import UnixSignals
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import Foundation

func buildWorker(
    config: WorkerConfig
) async throws -> ServiceGroup {

    let logger = {
        var logger = Logger(label: config.system.logger.label)
        logger.logLevel = config.system.logger.level
        return logger
    }()

    guard !config.ses.accessKeyId.isEmpty else {
        throw WorkerConfigurationError.missing("SES_ID")
    }
    guard !config.ses.secretAccessKey.isEmpty else {
        throw WorkerConfigurationError.missing("SES_SECRET")
    }
    guard !config.ses.region.isEmpty else {
        throw WorkerConfigurationError.missing("SES_REGION")
    }

    let awsClient = AWSClient(
        credentialProvider: .static(
            accessKeyId: config.ses.accessKeyId,
            secretAccessKey: config.ses.secretAccessKey
        ),
        logger: logger
    )
    let ses = SESv2(
        client: awsClient,
        region: .init(rawValue: config.ses.region),
        partition: .aws,
        endpoint: nil,
        timeout: nil,
        byteBufferAllocator: .init(),
        options: []
    )
    let emailService = EmailService(
        client: MailClientSES(
            ses: ses,
            encoder: RawMailEncoder(
                headerDateEncodingStrategy: {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US")
                    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
                    return formatter.string(from: Date())
                }
            )
        )
    )

    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    if FileManager.default.fileExists(atPath: config.system.database.rootCAPath)
    {
        let rootCert = try NIOSSLCertificate.fromPEMFile(
            config.system.database.rootCAPath
        )
        tlsConfig.trustRoots = .certificates(rootCert)
        tlsConfig.certificateVerification = .fullVerification
    }
    else {
        tlsConfig.certificateVerification = .none
    }

    let postgresConfiguration = PostgresClient.Configuration(
        host: config.system.database.host,
        port: config.system.database.port,
        username: config.system.database.user,
        password: config.system.database.password,
        database: config.system.database.database,
        tls: .require(tlsConfig)
    )

    let postgresClient = PostgresClient(
        configuration: postgresConfiguration,
        backgroundLogger: logger
    )
    let database = DatabaseClientPostgres(
        client: postgresClient,
        logger: logger
    )
    let idGenerator = NanoIDGenerator()

    let postgresMigrations = DatabaseMigrations()
    let jobQueue: JobQueue<PostgresJobQueue> = await JobQueue(
        .postgres(
            client: postgresClient,
            migrations: postgresMigrations,
            configuration: .init(
                pollTime: .milliseconds(config.queue.pollTimeMilliseconds),
                queueName: config.queue.name,
                retentionPolicy: .init(
                    completedJobs: .retain
                )
            ),
            logger: logger
        ),
        logger: logger
    )

    if !config.runMigrations {
        logger.warning(
            "WORKER_RUN_MIGRATIONS=false is ignored; worker queue migrations are always applied"
        )
    }

    let migrationClient = PostgresClient(
        configuration: postgresConfiguration,
        backgroundLogger: logger
    )
    let migrationClientTask = Task {
        await migrationClient.run()
    }
    defer { migrationClientTask.cancel() }
    try await Task.sleep(for: .milliseconds(100))
    try await postgresMigrations.apply(
        client: migrationClient,
        groups: [.jobQueue],
        logger: logger,
        dryRun: false
    )

    _ = JobController(
        queue: jobQueue,
        emailService: emailService,
        database: database
    )
    _ = MediaJobController(
        queue: jobQueue,
        database: database,
        idGenerator: idGenerator,
        storageRootPath: config.media.storageRootPath
    )

    var jobSchedule = JobSchedule()
    jobSchedule.addJob(
        jobQueue.queue.cleanupJob,
        parameters: PostgresJobCleanupParameters(
            completedJobs: PostgresJobQueue.JobCleanup.remove(
                maxAge: .seconds(
                    config.scheduler.cleanupCompletedJobsMaxAgeSeconds
                )
            )
        ),
        schedule: .hourly(
            minute: config.scheduler.cleanupHourMinute
        )
    )
    jobSchedule.addJob(
        jobQueue.queue.cleanupProcessingJob,
        parameters: PostgresProcessingJobCleanupParameters(
            maxJobsToProcess: config.scheduler.cleanupProcessingMaxJobs
        ),
        schedule: .onMinutes(
            Array(
                stride(
                    from: 0,
                    to: 60,
                    by: config.scheduler.cleanupProcessingIntervalMinutes
                )
            )
        )
    )
    let scheduler = await jobSchedule.scheduler(
        on: jobQueue,
        named: config.scheduler.name,
        options: .init(
            schedulerLock: .acquire(
                every: .seconds(config.scheduler.lockAcquireEverySeconds),
                for: .seconds(config.scheduler.lockForSeconds)
            )
        )
    )

    var services: [any Service] = [postgresClient, AWSClientLifecycleService(client: awsClient)]
    services.append(
        jobQueue.processor(
            options: JobQueueProcessorOptions(
                numWorkers: config.processor.workerCount,
                gracefulShutdownTimeout: .seconds(
                    config.processor.gracefulShutdownTimeoutSeconds
                )
            )
        )
    )
    services.append(scheduler)

    return ServiceGroup(
        configuration: .init(
            services: services,
            gracefulShutdownSignals: [.sigterm, .sigint],
            logger: logger
        )
    )
}
