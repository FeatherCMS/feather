import Environment

struct ServerConfig: Sendable {
    struct QueueConfig: Sendable {
        let name: String
        let pollTimeMilliseconds: Int
    }

    struct MediaConfig: Sendable {
        let storageRootPath: String
    }

    let host: String
    let port: Int
    let serverName: String?

    let system: SystemConfig
    let queue: QueueConfig
    let media: MediaConfig
}
