import Foundation
import Logging

struct ServerConfig: Sendable {
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

    struct Media: Sendable {
        let publicBaseURL: URL
    }

    struct Storage: Sendable {
        struct S3: Sendable {
            let accessKeyId: String
            let secretAccessKey: String
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

    let host: String
    let port: Int
    let serverName: String?

    let system: System
    let queue: Queue
    let storage: Storage
    let media: Media
}
