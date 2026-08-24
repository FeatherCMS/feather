import NewsletterAppAPI

public struct AppAPIGateway: Sendable, NewsletterAppAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
