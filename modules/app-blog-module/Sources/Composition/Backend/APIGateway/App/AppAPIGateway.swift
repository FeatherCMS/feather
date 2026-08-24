import BlogAppAPI

public struct AppAPIGateway: Sendable, BlogAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
