import Environment
import Configuration
import Foundation

struct ServerConfigLoader {

    let environmentLoader: EnvironmentLoader
    let systemConfigLoader: SystemConfigLoader

    init(
        environmentLoader: EnvironmentLoader = .init(),
        systemConfigLoader: SystemConfigLoader = .init()
    ) {
        self.environmentLoader = environmentLoader
        self.systemConfigLoader = systemConfigLoader
    }

    func load() async throws -> ServerConfig {
        let reader = try await environmentLoader.loadConfigReader(
            defaultEnvironmentFilePrefix: "server"
        )
        let system = systemConfigLoader.load(
            reader: reader
        )
        let queueReader = reader.scoped(to: "server.queue")
        let mediaReader = reader.scoped(to: "media")
        let objectKeyReader = reader.scoped(to: "storage.object_key")
        let storageReader = reader.scoped(to: "storage.s3")
        let serverHTTPReader = reader.scoped(to: "server.http")
        let storageEndpoint = storageReader.string(
            forKey: "endpoint",
            default: ""
        )
        let s3 = S3StorageConfig(
            accessKeyId: storageReader.string(
                forKey: "access_key_id",
                default: ""
            ),
            secretAccessKey: storageReader.string(
                forKey: "secret_access_key",
                default: ""
            ),
            region: storageReader.string(
                forKey: "region",
                default: ""
            ),
            endpoint: storageEndpoint.isEmpty ? nil : storageEndpoint,
            bucket: storageReader.string(
                forKey: "bucket",
                default: ""
            )
        )
        return .init(
            host: serverHTTPReader.string(
                forKey: "host",
                default: "0.0.0.0"
            ),
            port: serverHTTPReader.int(
                forKey: "port",
                default: 8080
            ),
            serverName: reader.string(forKey: "serverName"),
            system: system,
            queue: .init(
                name: queueReader.string(
                    forKey: "name",
                    default: "worker"
                ),
                pollTimeMilliseconds: max(
                    1,
                    queueReader.int(forKey: "poll_time_ms", default: 100)
                )
            ),
            storage: .init(
                s3: s3,
                objectKey: .init(
                    depth: max(
                        0,
                        objectKeyReader.int(forKey: "depth", default: 2)
                    ),
                    segmentLength: max(
                        1,
                        objectKeyReader.int(
                            forKey: "segment_length",
                            default: 2
                        )
                    )
                )
            ),
            media: .init(
                publicBaseURL: URL(
                    string: mediaReader.string(
                        forKey: "public_base_url",
                        default: "http://localhost:8081"
                    )
                )!
            )
        )
    }
}
