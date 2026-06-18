import FeatherDatabase
import FeatherDatabasePostgres
import Foundation
import Logging
import PostgresNIO
import ServiceLifecycle
import Environment
import Foundation

public struct TestDatabaseClient {

    private let config: SystemConfig.DatabaseConfig
    private let logger: Logger

    public init(
        config: SystemConfig.DatabaseConfig,
        logger: Logger
    ) {
        self.config = config
        self.logger = logger
    }

    // MARK: - setup helpers

    func getPostgresClient() throws -> PostgresClient {
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        if FileManager.default.fileExists(atPath: config.rootCAPath) {
            let rootCert = try NIOSSLCertificate.fromPEMFile(
                config.rootCAPath
            )
            tlsConfig.trustRoots = .certificates(rootCert)
            tlsConfig.certificateVerification = .fullVerification
        }
        else {
            tlsConfig.certificateVerification = .none
        }

        let client = PostgresClient(
            configuration: .init(
                host: config.host,
                port: config.port,
                username: config.user,
                password: config.password,
                database: config.database,
                tls: .require(tlsConfig)
            ),
            backgroundLogger: logger
        )
        return client
    }

    public func execute(
        _ block: @Sendable @escaping (any DatabaseClient) async throws -> Void
    ) async throws {
        let client = try getPostgresClient()
        let database = DatabaseClientPostgres(
            client: client,
            logger: logger
        )
        let clientTask = Task {
            await client.run()
        }
        defer { clientTask.cancel() }

        try await Task.sleep(for: .milliseconds(100))
        try await block(database)
    }
}
