import BlogAdminAPI

public struct AdminAPIGateway: Sendable, BlogAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
