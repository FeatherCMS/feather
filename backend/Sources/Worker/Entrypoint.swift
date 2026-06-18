import ServiceLifecycle

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await WorkerConfigLoader().load()
        let worker = try await buildWorker(
            config: config
        )
        try await worker.run()
    }
}
