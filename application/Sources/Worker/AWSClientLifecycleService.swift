import ServiceLifecycle
import SotoCore

struct AWSClientLifecycleService: Service {
    let client: AWSClient

    func run() async throws {
        do {
            while true {
                try await Task.sleep(for: .seconds(3600))
            }
        }
        catch is CancellationError {
            // The service group is shutting down.
        }
        try await client.shutdown()
    }
}
