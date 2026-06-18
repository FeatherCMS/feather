import Application
import FeatherDatabase
import FeatherDatabasePostgres
import Environment
import Infrastructure
import Logging
import NIOSSL
import PostgresNIO
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await MigratorConfigLoader().loadMigratorConfig()

        let logger = {
            var logger = Logger(label: config.system.logger.label)
            logger.logLevel = config.system.logger.level
            return logger
        }()

        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        if FileManager.default.fileExists(
            atPath: config.system.database.rootCAPath
        ) {
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
            backgroundLogger: logger
        )

        let database = DatabaseClientPostgres(
            client: client,
            logger: logger
        )

        let clientTask = Task {
            await client.run()
        }
        defer { clientTask.cancel() }
        try await Task.sleep(for: .milliseconds(25))

        try await database.withConnection { connection in
            if config.reset {
                try await connection.run(
                    query: #"""
                        DROP SCHEMA IF EXISTS swift_jobs CASCADE;
                        DROP SCHEMA public CASCADE;
                        CREATE SCHEMA public;
                        """#
                ) { _ in }
            }

            let migrator = Migrator(
                migrations: buildMigrations(connection: connection),
                logger: logger
            )
            try await migrator.apply(on: connection)
        }

        logger.info("Database is now migrated.")
    }
}
