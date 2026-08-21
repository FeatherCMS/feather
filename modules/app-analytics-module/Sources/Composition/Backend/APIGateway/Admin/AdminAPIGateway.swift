import AnalyticsAdminAPI

public struct AdminAPIGateway: Sendable, AnalyticsAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
