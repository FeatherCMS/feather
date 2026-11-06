public import FeatherModuleKit
public import MediaBackend
public import WebAppAPI

public struct AppAPIGateway: Sendable, WebAppAPI.APIProtocol {
    public let useCases: UseCases
    let mediaUseCases: MediaBackend.UseCases
    let mediaResolver: MediaResolver

    public init(
        useCases: UseCases,
        mediaUseCases: MediaBackend.UseCases,
        mediaResolver: MediaResolver
    ) {
        self.useCases = useCases
        self.mediaUseCases = mediaUseCases
        self.mediaResolver = mediaResolver
    }
}
