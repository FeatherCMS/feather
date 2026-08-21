import AnalyticsAppAPI

public struct AppAPIGateway: Sendable, AnalyticsAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
