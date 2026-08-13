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
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

typealias AppRequestContext = BasicRequestContext

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
    let events = buildAppEventPublisher()

    let modules = AppModules(
        infrastructure: .init(
            database: database,
            idGenerator: idGenerator,
            events: events,
            jobQueue: jobQueue,
            mediaStorageRootPath: config.media.storageRootPath
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
