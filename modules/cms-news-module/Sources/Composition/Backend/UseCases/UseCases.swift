public import FeatherInfrastructure
public import FeatherModuleKit
public import MediaBackend

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let media: MediaBackend.UseCases
    let mediaResolver: MediaResolver

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        media: MediaBackend.UseCases,
        mediaResolver: MediaResolver
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.media = media
        self.mediaResolver = mediaResolver
    }
}
