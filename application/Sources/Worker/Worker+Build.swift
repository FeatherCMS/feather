import Environment
import FeatherApplication
import FeatherSotoSES
import FeatherMail
import FeatherMailSES
import FeatherDomain
import FeatherInfrastructure
import FeatherStorage
import FeatherStorageS3
import Jobs
import JobsPostgres
import Logging
import FeatherDatabasePostgres
import FeatherDBALPostgres
import NIOSSL
import PostgresMigrations
import PostgresNIO
import ServiceLifecycle
import SotoCore
import UnixSignals
import MediaInfrastructure
import Foundation
import MediaApplication

func buildWorker(
    config: WorkerConfig
) async throws -> ServiceGroup {
    guard !config.ses.accessKeyId.isEmpty else {
        throw WorkerConfigurationError.missing("SES_ID")
    }
    guard !config.ses.secretAccessKey.isEmpty else {
        throw WorkerConfigurationError.missing("SES_SECRET")
    }
    guard !config.ses.region.isEmpty else {
        throw WorkerConfigurationError.missing("SES_REGION")
    }
    if config.storage.s3.accessKeyId.isEmpty
        != config.storage.s3.secretAccessKey.isEmpty
    {
        let name =
            config.storage.s3.accessKeyId.isEmpty
            ? "STORAGE_S3_ACCESS_KEY_ID"
            : "STORAGE_S3_SECRET_ACCESS_KEY"
        throw WorkerConfigurationError.missing(name)
    }
    guard !config.storage.s3.region.isEmpty else {
        throw WorkerConfigurationError.missing("STORAGE_S3_REGION")
    }
    guard !config.storage.s3.bucket.isEmpty else {
        throw WorkerConfigurationError.missing("STORAGE_S3_BUCKET")
    }
    guard
        let publicBaseURL = URL(string: config.webPublicBaseURL),
        ["http", "https"].contains(publicBaseURL.scheme),
        publicBaseURL.host != nil
    else {
        throw WorkerConfigurationError.missing("WEB_PUBLIC_BASE_URL")
    }

    let awsClient = AWSClient(
        credentialProvider: .static(
            accessKeyId: config.ses.accessKeyId,
            secretAccessKey: config.ses.secretAccessKey
        ),
        logger: Logger.current
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
    let mailClient = MailClientSES(
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

    let storageCredentialProvider: CredentialProviderFactory
    if config.storage.s3.accessKeyId.isEmpty {
        storageCredentialProvider = .default
    }
    else {
        storageCredentialProvider = .static(
            accessKeyId: config.storage.s3.accessKeyId,
            secretAccessKey: config.storage.s3.secretAccessKey
        )
    }
    let storageAWSClient = AWSClient(
        credentialProvider: storageCredentialProvider,
        logger: Logger.current
    )
    let storage = StorageClientS3(
        awsClient: storageAWSClient,
        region: config.storage.s3.region,
        endpoint: config.storage.s3.endpoint,
        bucket: config.storage.s3.bucket
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
        backgroundLogger: Logger.current
    )
    let database = DatabaseClientPostgres(
        client: postgresClient
    )
    let idGenerator = NanoIDGenerator()
    let databaseContext = DatabaseClientContext(
        database: database,
        idGenerator: idGenerator,
        platform: PostgresDatabasePlatform()
    )

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
            logger: Logger.current
        ),
        logger: Logger.current
    )

    if !config.runMigrations {
        Logger.current.warning(
            "WORKER_RUN_MIGRATIONS=false is ignored; worker queue migrations are always applied"
        )
    }

    let migrationClient = PostgresClient(
        configuration: postgresConfiguration,
        backgroundLogger: Logger.current
    )
    let migrationClientTask = Task {
        await migrationClient.run()
    }
    defer { migrationClientTask.cancel() }
    try await Task.sleep(for: .milliseconds(100))
    try await postgresMigrations.apply(
        client: migrationClient,
        groups: [.jobQueue],
        logger: Logger.current,
        dryRun: false
    )

    _ = JobController(
        queue: jobQueue,
        mailClient: mailClient,
        databaseContext: databaseContext,
        storageContext: .init(
            storage: storage,
            objectKeyGenerator: HierarchicalObjectKeyGenerator(
                depth: config.storage.objectKey.depth,
                segmentLength: config.storage.objectKey.segmentLength
            )
        ),
        maxConcurrentMediaProcessing: config.media.maxConcurrentProcessing,
        publicBaseURL: publicBaseURL
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
        parameters: PostgresOrphanedJobCleanupParameters(
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

    var services: [any Service] = [postgresClient, awsClient, storageAWSClient]
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
            logger: Logger.current
        )
    )
}
