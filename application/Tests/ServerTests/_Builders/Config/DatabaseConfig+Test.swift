import Testing

@testable import Environment
@testable import Server

extension SystemConfig.DatabaseConfig {

    static func test(
        database: String
    ) -> Self {
        .init(
            host: "127.0.0.1",
            port: 5432,
            user: "postgres",
            password: "postgres",
            database: database,
            rootCAPath: "./docker/certs/ca.pem"
        )
    }
}
