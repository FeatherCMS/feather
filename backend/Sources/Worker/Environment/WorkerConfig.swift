import Environment

struct WorkerConfig: Sendable {

    struct QueueConfig: Sendable {
        let name: String
        let pollTimeMilliseconds: Int
    }

    struct ProcessorConfig: Sendable {
        let workerCount: Int
        let gracefulShutdownTimeoutSeconds: Int
    }

    struct SchedulerConfig: Sendable {
        let name: String
        let cleanupCompletedJobsMaxAgeSeconds: Int
        let cleanupHourMinute: Int
        let cleanupProcessingIntervalMinutes: Int
        let cleanupProcessingMaxJobs: Int
        let lockAcquireEverySeconds: Int
        let lockForSeconds: Int
    }

    struct MediaConfig: Sendable {
        let storageRootPath: String
    }

    let system: SystemConfig
    let queue: QueueConfig
    let processor: ProcessorConfig
    let scheduler: SchedulerConfig
    let media: MediaConfig
    let runMigrations: Bool
}
