import Configuration

public struct AppEnvironmentURLResolver {
    public let reader: ConfigReader

    public init(reader: ConfigReader) {
        self.reader = reader
    }

    public func publicSiteBaseURL() -> String {
        reader.string(
            forKey: "web.publicBaseURL",
            default: "http://localhost:3456"
        )
    }

    public func publicStaticBaseURL() -> String {
        reader.string(
            forKey: "static.publicBaseURL",
            default: "http://localhost:4567"
        )
    }

    public func apiBaseURL() -> String {
        reader.string(
            forKey: "api.baseURL",
            default: "http://localhost:8080"
        )
    }

    public func publicMediaBaseURL() -> String {
        reader.string(
            forKey: "media.publicBaseURL",
            default: "http://localhost:8080"
        )
    }
}
