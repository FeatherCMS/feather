import Configuration
import Environment

struct WorkerConfigLoader {

    let environmentLoader: EnvironmentLoader
    let systemConfigLoader: SystemConfigLoader

    init(
        environmentLoader: EnvironmentLoader = .init(),
        systemConfigLoader: SystemConfigLoader = .init()
    ) {
        self.environmentLoader = environmentLoader
        self.systemConfigLoader = systemConfigLoader
    }

    func load() async throws -> WorkerConfig {
        let reader = try await environmentLoader.loadConfigReader(
            defaultEnvironmentFilePrefix: "worker"
        )
        let workerScope = reader.scoped(to: "worker")
        let mediaScope = reader.scoped(to: "media")

        return .init(
            system: systemConfigLoader.load(reader: reader),
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
            media: .init(
                storageRootPath: mediaScope.string(
                    forKey: "storage_root_path",
                    default: "/tmp/backend-media"
                )
            ),
            runMigrations: workerScope.bool(
                forKey: "run_migrations",
                default: true
            )
        )
    }
}
