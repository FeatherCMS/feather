import AuthAdminAPI

public struct AdminAPIGateway: Sendable, AuthAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
