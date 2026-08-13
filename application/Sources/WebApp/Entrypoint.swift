import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
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
                    "http.serverName": "web-app",
                    "http.host": "0.0.0.0",
                    "http.port": 3456,
                ]),
            ]
        )
        var logger = Logger(label: "web-app")
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
