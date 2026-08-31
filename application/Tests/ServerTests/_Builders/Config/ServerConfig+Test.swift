import Logging
import Testing

@testable import Environment
@testable import Server

extension ServerConfig {

    static func test(
        database: String
    ) -> Self {
        .init(
            host: "127.0.0.1",
            port: 8080,
            serverName: "test",
            system: .init(
                logger: .init(level: .info, label: "test"),
                database: .test(database: database)
            ),
            queue: .init(
                name: "test",
                pollTimeMilliseconds: 100
            ),
            media: .init(
                storageRootPath: "/tmp/backend-media-tests"
            )
        )
    }
}
