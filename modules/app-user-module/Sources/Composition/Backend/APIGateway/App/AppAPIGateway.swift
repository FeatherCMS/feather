import UserAppAPI

public struct AppAPIGateway: Sendable, UserAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
