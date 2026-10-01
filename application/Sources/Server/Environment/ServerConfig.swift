import Environment
import Foundation

struct ServerConfig: Sendable {
    struct QueueConfig: Sendable {
        let name: String
        let pollTimeMilliseconds: Int
    }

    struct MediaConfig: Sendable {
        let storageRootPath: String
        let publicBaseURL: URL
    }

    struct StorageConfig: Sendable {
        struct ObjectKeyConfig: Sendable {
            let depth: Int
            let segmentLength: Int
        }

        let objectKey: ObjectKeyConfig
    }

    let host: String
    let port: Int
    let serverName: String?

    let system: SystemConfig
    let queue: QueueConfig
    let storage: StorageConfig
    let media: MediaConfig
}
