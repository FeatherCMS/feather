import Logging
import Foundation
import Testing

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
            storage: .init(
                s3: .init(
                    region: "us-east-1",
                    endpoint: nil,
                    bucket: "test"
                ),
                objectKey: .init(depth: 0, segmentLength: 2)
            ),
            media: .init(
                publicBaseURL: URL(string: "http://localhost:8080")!
            )
        )
    }
}
