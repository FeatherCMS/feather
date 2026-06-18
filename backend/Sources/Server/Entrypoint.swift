import Application
import Hummingbird

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await ServerConfigLoader().load()
        let server = try await buildServer(config: config)
        try await server.runService()
    }
}
