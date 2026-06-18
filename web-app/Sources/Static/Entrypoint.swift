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
                    "http.serverName": "static",
                    "http.host": "0.0.0.0",
                    "http.port": 4567,
                ]),
            ]
        )
        let app = try await buildApplication(reader: reader)
        try await app.runService()
    }
}
