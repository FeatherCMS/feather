import BlogApplication
import BlogInfrastructure
import FeatherApplication
public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import MediaBackend
import SystemInfrastructure
import WebInfrastructure

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
