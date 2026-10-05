import Hummingbird
import Logging
import FeatherDatabase
import FeatherDatabasePostgres
import Jobs
import JobsPostgres
import NIOSSL
import PostgresMigrations
import PostgresNIO
import Environment
import FeatherInfrastructure
import FeatherDomain
import FeatherStorage
import FeatherStorageFS
import MediaApplication
import MediaInfrastructure
import FeatherContracts
import FeatherAdmin
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

typealias DefaultRequestContext = BasicRequestContext

func buildServer(
    config: ServerConfig
) async throws -> some ApplicationProtocol {
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
        idGenerator: idGenerator
    )
    let events = buildAppEventPublisher()

    let modules = AppModules(
        infrastructure: .init(
            databaseContext: databaseContext,
            events: events,
            jobQueue: jobQueue,
            storageContext: .init(
                storage: StorageClientFS(
                    rootPath: config.media.storageRootPath
                ),
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

    return app
}
