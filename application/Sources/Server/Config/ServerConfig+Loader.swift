import Configuration
import SystemPackage
import Foundation
import Logging

extension ServerConfig {
    struct Loader {

        func load() async throws -> ServerConfig {
            let reader = try await loadConfigReader(defaultFileName: "server")
            return try load(reader: reader)
        }

        func load(reader: ConfigReader) throws -> ServerConfig {
            let system = loadSystemConfig(reader: reader)
            let mediaPublicBaseURLString = reader.scoped(to: "media")
                .string(
                    forKey: "public_base_url",
                    default: "http://localhost:8081"
                )
            guard
                let mediaPublicBaseURL = URL(string: mediaPublicBaseURLString),
                ["http", "https"].contains(mediaPublicBaseURL.scheme),
                mediaPublicBaseURL.host != nil
            else {
                throw ServerConfig.Error.invalidURL("MEDIA_PUBLIC_BASE_URL")
            }
            let queueReader = reader.scoped(to: "server.queue")
            let objectKeyReader = reader.scoped(to: "storage.object_key")
            let storageReader = reader.scoped(to: "storage.s3")
            let serverHTTPReader = reader.scoped(to: "server.http")
            let storageEndpoint = storageReader.string(
                forKey: "endpoint",
                default: ""
            )
            let s3 = ServerConfig.Storage.S3(
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
                    publicBaseURL: mediaPublicBaseURL
                )
            )
        }

        private func loadSystemConfig(
            reader: ConfigReader
        ) -> ServerConfig.System {
            let logger = reader.scoped(to: "logger")
            let postgres = reader.scoped(to: "postgres")
            return .init(
                logger: .init(
                    level: logger.string(
                        forKey: "level",
                        as: Logger.Level.self,
                        default: .info
                    ),
                    label: logger.string(forKey: "label", default: "backend")
                ),
                database: .init(
                    host: postgres.string(forKey: "host", default: "127.0.0.1"),
                    port: postgres.int(forKey: "port", default: 5432),
                    user: postgres.string(forKey: "user", default: "postgres"),
                    password: postgres.string(
                        forKey: "password",
                        default: "postgres"
                    ),
                    database: postgres.string(
                        forKey: "database",
                        default: "postgres"
                    ),
                    rootCAPath: postgres.string(
                        forKey: "root_ca_path",
                        default: "/certs/ca.pem"
                    )
                )
            )
        }

        private func loadConfigReader(
            defaultFileName: String
        ) async throws -> ConfigReader {
            let arguments = ConfigReader(providers: [
                CommandLineArgumentsProvider()
            ])
            let environment = arguments.string(forKey: "env", default: "dev")
                .lowercased()
            let filePath = arguments.string(forKey: "env.filePath")
            var providers: [any ConfigProvider] = [
                EnvironmentVariablesProvider()
            ]
            if let filePath {
                providers.append(
                    try await EnvironmentVariablesProvider(
                        environmentFilePath: .init(filePath),
                        allowMissing: false
                    )
                )
            }
            else {
                providers.append(
                    try await EnvironmentVariablesProvider(
                        environmentFilePath: .init(
                            "\(defaultFileName).\(environment).env"
                        ),
                        allowMissing: true
                    )
                )
            }
            return ConfigReader(providers: providers)
        }
    }
}
