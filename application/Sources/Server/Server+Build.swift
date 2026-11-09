import Hummingbird
import FeatherWebShared
import Logging
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherDBALPostgres
import Jobs
import JobsPostgres
import NIOSSL
import PostgresMigrations
import PostgresNIO
import FeatherApplication
import FeatherInfrastructure
import FeatherDomain
import FeatherStorage
import FeatherStorageS3
import SotoCore
import MediaApplication
import MediaInfrastructure
import FeatherModuleKit
import FeatherWebAdmin
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

func buildServer(
    config: ServerConfig
) async throws -> some ApplicationProtocol {
    guard !config.storage.s3.region.isEmpty else {
        throw ServerConfig.Error.missing("STORAGE_S3_REGION")
    }
    guard !config.storage.s3.bucket.isEmpty else {
        throw ServerConfig.Error.missing("STORAGE_S3_BUCKET")
    }

    let storageAWSClient = AWSClient(
        credentialProvider: .default,
        logger: Logger.current
    )
    let storageClient = StorageClientS3(
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

    let client = PostgresClient(
        configuration: .init(
            host: config.system.database.host,
            port: config.system.database.port,
            username: config.system.database.user,
            password: config.system.database.password,
            database: config.system.database.database,
            tls: .require(tlsConfig)
        ),
        backgroundLogger: Logger.current
    )

    let database = DatabaseClientPostgres(
        client: client
    )
    let postgresMigrations = DatabaseMigrations()
    let jobQueue: JobQueue<PostgresJobQueue> = await JobQueue(
        .postgres(
            client: client,
            migrations: postgresMigrations,
            configuration: .init(
                pollTime: .milliseconds(config.queue.pollTimeMilliseconds),
                queueName: config.queue.name
            ),
            logger: Logger.current
        ),
        logger: Logger.current
    )

    let idGenerator = NanoIDGenerator()
    let databaseContext = DatabaseClientContext(
        database: database,
        idGenerator: idGenerator,
        platform: PostgresDatabasePlatform()
    )
    let events = buildAppEventPublisher()

    let modules = AppModules(
        infrastructure: .init(
            databaseContext: databaseContext,
            events: events,
            jobQueue: jobQueue,
            storageContext: .init(
                storage: storageClient,
                objectKeyGenerator: HierarchicalObjectKeyGenerator(
                    depth: config.storage.objectKey.depth,
                    segmentLength: config.storage.objectKey.segmentLength
                )
            )
        ),
        mediaResolver: MediaResolver(
            mediaBaseURL: config.media.publicBaseURL
        )
    )

    let router = try buildRouter(
        modules: modules
    )

    let applicationConfiguration = ApplicationConfiguration(
        address: .hostname(config.host, port: config.port),
        serverName: config.serverName
    )

    var app = Application(
        router: router,
        configuration: applicationConfiguration,
        logger: Logger.current
    )

    app.addServices(
        client
    )
    app.addServices(
        storageAWSClient
    )

    return app
}
