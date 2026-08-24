import SystemAppAPI

public struct AppAPIGateway: Sendable, SystemAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
