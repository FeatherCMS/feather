import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let media: MediaBackend.UseCases
    let mediaResolver: MediaResolver

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        media: MediaBackend.UseCases,
        mediaResolver: MediaResolver
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.media = media
        self.mediaResolver = mediaResolver
    }
}
