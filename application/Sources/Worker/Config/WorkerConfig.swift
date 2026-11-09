import Foundation
import Logging

struct WorkerConfig: Sendable {
    enum Error: Swift.Error {
        case missing(String)
        case invalidURL(String)
    }

    struct System: Sendable {
        struct Database: Sendable {
            let host: String
            let port: Int
            let user: String
            let password: String
            let database: String
            let rootCAPath: String
        }

        struct Logger: Sendable {
            let level: Logging.Logger.Level
            let label: String
        }

        let logger: Logger
        let database: Database
    }

    struct Queue: Sendable {
        let name: String
        let pollTimeMilliseconds: Int
    }

    struct Processor: Sendable {
        let workerCount: Int
        let gracefulShutdownTimeoutSeconds: Int
    }

    struct Scheduler: Sendable {
        let name: String
        let cleanupCompletedJobsMaxAgeSeconds: Int
        let cleanupHourMinute: Int
        let cleanupProcessingIntervalMinutes: Int
        let cleanupProcessingMaxJobs: Int
        let lockAcquireEverySeconds: Int
        let lockForSeconds: Int
    }

    struct Media: Sendable {
        let maxConcurrentProcessing: Int
    }

    struct Storage: Sendable {
        struct S3: Sendable {
            let region: String
            let endpoint: String?
            let bucket: String
        }

        struct ObjectKey: Sendable {
            let depth: Int
            let segmentLength: Int
        }

        let s3: S3
        let objectKey: ObjectKey
    }

    struct SES: Sendable {
        let region: String
        let endpoint: String?
    }

    let system: System
    let webPublicBaseURL: URL
    let queue: Queue
    let processor: Processor
    let scheduler: Scheduler
    let storage: Storage
    let media: Media
    let ses: SES
    let runMigrations: Bool
}
