import ContactAppAPI

public struct AppAPIGateway: Sendable, ContactAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
