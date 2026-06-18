import Environment
import Configuration

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
        let serverHTTPReader = reader.scoped(to: "server.http")
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
            media: .init(
                storageRootPath: mediaReader.string(
                    forKey: "storage_root_path",
                    default: "/tmp/backend-media"
                )
            )
        )
    }
}
