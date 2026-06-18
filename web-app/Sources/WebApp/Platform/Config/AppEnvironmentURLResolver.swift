import Configuration

struct AppEnvironmentURLResolver {
    let reader: ConfigReader

    func publicSiteBaseURL() -> String {
        reader.string(
            forKey: "web.publicBaseURL",
            default: "http://localhost:3456"
        )
    }

    func publicStaticBaseURL() -> String {
        reader.string(
            forKey: "static.publicBaseURL",
            default: "http://localhost:4567"
        )
    }

    func apiBaseURL() -> String {
        reader.string(
            forKey: "api.baseURL",
            default: "http://localhost:8080"
        )
    }

    func publicMediaBaseURL() -> String {
        reader.string(
            forKey: "media.publicBaseURL",
            default: "http://localhost:8080"
        )
    }
}
