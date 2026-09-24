public import FeatherContracts
public import MediaAdminAPI

public struct AdminAPIGateway: Sendable, MediaAdminAPI.APIProtocol {
    public let useCases: UseCases
    public let mediaResolver: MediaResolver

    public init(
        useCases: UseCases,
        mediaResolver: MediaResolver
    ) {
        self.useCases = useCases
        self.mediaResolver = mediaResolver
    }
}
