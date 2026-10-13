public import NewsAdminAPI

public struct AdminAPIGateway: Sendable, NewsAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
