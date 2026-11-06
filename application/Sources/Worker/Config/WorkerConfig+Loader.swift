import Configuration
import SystemPackage
import Foundation
import Logging

extension WorkerConfig {
    struct Loader {

        func load() async throws -> WorkerConfig {
            let reader = try await loadConfigReader(defaultFileName: "worker")
            return try load(reader: reader)
        }

        func load(reader: ConfigReader) throws -> WorkerConfig {
            let workerScope = reader.scoped(to: "worker")
            let mediaScope = reader.scoped(to: "media")
            let objectKeyScope = reader.scoped(to: "storage.object_key")
            let storageScope = reader.scoped(to: "storage.s3")
            let sesScope = reader.scoped(to: "ses")
            let storageEndpoint = storageScope.string(
                forKey: "endpoint",
                default: ""
            )
            let s3 = WorkerConfig.Storage.S3(
                accessKeyId: storageScope.string(
                    forKey: "access_key_id",
                    default: ""
                ),
                secretAccessKey: storageScope.string(
                    forKey: "secret_access_key",
                    default: ""
                ),
                region: storageScope.string(
                    forKey: "region",
                    default: ""
                ),
                endpoint: storageEndpoint.isEmpty ? nil : storageEndpoint,
                bucket: storageScope.string(
                    forKey: "bucket",
                    default: ""
                )
            )

            let webPublicBaseURLString = reader.string(
                forKey: "web.publicBaseURL",
                default: "http://localhost:3456"
            )
            guard
                let webPublicBaseURL = URL(string: webPublicBaseURLString),
                ["http", "https"].contains(webPublicBaseURL.scheme),
                webPublicBaseURL.host != nil
            else {
                throw WorkerConfig.Error.invalidURL("WEB_PUBLIC_BASE_URL")
            }

            return .init(
                system: loadSystemConfig(reader: reader),
                webPublicBaseURL: webPublicBaseURL,
                queue: .init(
                    name: workerScope.string(
                        forKey: "queue_name",
                        default: "worker"
                    ),
                    pollTimeMilliseconds: max(
                        1,
                        workerScope.int(
                            forKey: "poll_time_ms",
                            default: 100
                        )
                    )
                ),
                processor: .init(
                    workerCount: max(
                        1,
                        workerScope.int(
                            forKey: "num_workers",
                            default: 16
                        )
                    ),
                    gracefulShutdownTimeoutSeconds: max(
                        1,
                        workerScope.int(
                            forKey: "graceful_shutdown_timeout_seconds",
                            default: 10
                        )
                    )
                ),
                scheduler: .init(
                    name: workerScope.string(
                        forKey: "scheduler_name",
                        default: "worker"
                    ),
                    cleanupCompletedJobsMaxAgeSeconds: max(
                        0,
                        workerScope.int(
                            forKey: "cleanup_completed_max_age_seconds",
                            default: 24 * 60 * 60
                        )
                    ),
                    cleanupHourMinute: min(
                        59,
                        max(
                            0,
                            workerScope.int(
                                forKey: "cleanup_hourly_minute",
                                default: 52
                            )
                        )
                    ),
                    cleanupProcessingIntervalMinutes: min(
                        59,
                        max(
                            1,
                            workerScope.int(
                                forKey: "cleanup_processing_interval_minutes",
                                default: 5
                            )
                        )
                    ),
                    cleanupProcessingMaxJobs: max(
                        1,
                        workerScope.int(
                            forKey: "cleanup_processing_max_jobs",
                            default: 100
                        )
                    ),
                    lockAcquireEverySeconds: max(
                        1,
                        workerScope.int(
                            forKey: "scheduler_lock_every_seconds",
                            default: 300
                        )
                    ),
                    lockForSeconds: max(
                        1,
                        workerScope.int(
                            forKey: "scheduler_lock_for_seconds",
                            default: 360
                        )
                    )
                ),
                storage: .init(
                    s3: s3,
                    objectKey: .init(
                        depth: max(
                            0,
                            objectKeyScope.int(forKey: "depth", default: 2)
                        ),
                        segmentLength: max(
                            1,
                            objectKeyScope.int(
                                forKey: "segment_length",
                                default: 2
                            )
                        )
                    )
                ),
                media: .init(
                    maxConcurrentProcessing: max(
                        1,
                        mediaScope.int(
                            forKey: "max_concurrent_processing",
                            default: 1
                        )
                    )
                ),
                ses: .init(
                    accessKeyId: sesScope.string(
                        forKey: "id",
                        default: ""
                    ),
                    secretAccessKey: sesScope.string(
                        forKey: "secret",
                        default: ""
                    ),
                    region: sesScope.string(
                        forKey: "region",
                        default: ""
                    )
                ),
                runMigrations: workerScope.bool(
                    forKey: "run_migrations",
                    default: true
                )
            )
        }

        private func loadSystemConfig(
            reader: ConfigReader
        ) -> WorkerConfig.System {
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
