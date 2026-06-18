import Configuration
import Hummingbird
import Logging

@main
struct Entrypoint {

    static func main() async throws {
        let reader = try await ConfigReader(
            providers: [
                //            CommandLineArgumentsProvider(),
                EnvironmentVariablesProvider(),
                EnvironmentVariablesProvider(
                    environmentFilePath: ".env",
                    allowMissing: true
                ),
                InMemoryProvider(values: [
                    "http.serverName": "web-app",
                    "http.host": "0.0.0.0",
                    "http.port": 3456,
                ]),
            ]
        )
        let app = try await buildApplication(reader: reader)
        try await app.runService()
    }
}
