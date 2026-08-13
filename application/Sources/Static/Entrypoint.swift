import Configuration
import Hummingbird
import Logging
import SystemPackage

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
        var logger = Logger(label: "static")
        logger.logLevel = reader.string(
            forKey: "log.level",
            as: Logger.Level.self,
            default: .info
        )
        try await withLogger(logger) { _ in
            let app = try await buildApplication(reader: reader)
            try await app.runService()
        }
    }
}
