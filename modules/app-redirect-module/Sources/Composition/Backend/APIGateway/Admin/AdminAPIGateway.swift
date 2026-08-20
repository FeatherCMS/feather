import RedirectAdminAPI

public struct AdminAPIGateway: Sendable, RedirectAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
