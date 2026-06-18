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
    client: TestDatabaseClient,
    logger: Logger
) async throws -> some ApplicationProtocol {

    let postgresClient = try client.getPostgresClient()

    let database = DatabaseClientPostgres(
        client: postgresClient,
        logger: logger
    )

    let idGenerator = NanoIDGenerator()
    let jobQueue = JobQueue(
        MemoryQueue(queueName: config.queue.name),
        logger: logger
    )

    let modules = AppModules(
        infrastructure: .init(
            database: database,
            idGenerator: idGenerator,
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
        logger: logger
    )

    app.addServices(
        postgresClient
    )

    return app
}
