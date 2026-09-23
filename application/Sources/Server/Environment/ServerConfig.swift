import Environment
import Foundation

struct ServerConfig: Sendable {
    struct QueueConfig: Sendable {
        let name: String
        let pollTimeMilliseconds: Int
    }

    struct MediaConfig: Sendable {
        let storageRootPath: String
        let storageShardDepth: Int
        let storageShardSegmentLength: Int
        let publicBaseURL: URL
    }

    let host: String
    let port: Int
    let serverName: String?

    let system: SystemConfig
    let queue: QueueConfig
    let media: MediaConfig
}
