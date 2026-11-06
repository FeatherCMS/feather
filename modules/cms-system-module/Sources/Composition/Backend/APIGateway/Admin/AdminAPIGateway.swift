public import SystemAdminAPI
import SystemModule

public struct AdminAPIGateway: Sendable, SystemAdminAPI.APIProtocol {
    public let useCases: UseCases

    public init(useCases: UseCases) {
        self.useCases = useCases
    }
}
