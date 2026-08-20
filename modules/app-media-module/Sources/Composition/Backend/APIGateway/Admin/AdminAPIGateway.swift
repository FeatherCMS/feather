import MediaAdminAPI

public struct AdminAPIGateway: Sendable, MediaAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
