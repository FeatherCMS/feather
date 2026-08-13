import Hummingbird
import Logging
import FeatherDatabase
import FeatherDatabasePostgres
import NIOSSL
import PostgresNIO
import Environment
import Jobs
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

func buildTestServer(
    config: ServerConfig,
    client: TestDatabaseClient
) async throws -> some ApplicationProtocol {

    let postgresClient = try client.getPostgresClient()

    let database = DatabaseClientPostgres(
        client: postgresClient
    )

    let idGenerator = NanoIDGenerator()
    let eventPublisher = buildAppEventPublisher()
    let jobQueue = JobQueue(
        MemoryQueue(queueName: config.queue.name),
        logger: Logger.current
    )

    let modules = AppModules(
        infrastructure: .init(
            database: database,
            idGenerator: idGenerator,
            events: eventPublisher,
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
        postgresClient
    )

    return app
}
