import BlogAdminAPI
import BlogAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebFrontend

extension AdminViewMediaAssetOpenAPIRepository {
    init(api: BlogAdminAPIClient) {
        self.init(
            api: MediaAdminAPIClient(
                apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
                sessionToken: api.sessionToken
            )
        )
    }
}

public struct AppPublicAuthorLinkModel: Sendable {
    public let label: String
    public let url: String
    public let isBlank: Bool

    public init(label: String, url: String, isBlank: Bool) {
        self.label = label
        self.url = url
        self.isBlank = isBlank
    }
}

public struct AppPublicPostSummaryModel: Sendable {
    public let title: String
    public let excerpt: String
    public let href: String
    public let publishedAt: String?
    public let metadata: AppPublicMetadataModel

    public init(
        title: String,
        excerpt: String,
        href: String,
        publishedAt: String?,
        metadata: AppPublicMetadataModel
    ) {
        self.title = title
        self.excerpt = excerpt
        self.href = href
        self.publishedAt = publishedAt
        self.metadata = metadata
    }
}

public struct AppPublicAuthorSummaryModel: Sendable {
    public let name: String
    public let excerpt: String
    public let href: String
    public let imageURL: String?
    public let metadata: AppPublicMetadataModel

    public init(
        name: String,
        excerpt: String,
        href: String,
        imageURL: String?,
        metadata: AppPublicMetadataModel
    ) {
        self.name = name
        self.excerpt = excerpt
        self.href = href
        self.imageURL = imageURL
        self.metadata = metadata
    }
}

public struct AppPublicTagSummaryModel: Sendable {
    public let title: String
    public let excerpt: String
    public let href: String
    public let imageURL: String?
    public let metadata: AppPublicMetadataModel
    public let exclusive: Bool

    public init(
        title: String,
        excerpt: String,
        href: String,
        imageURL: String?,
        metadata: AppPublicMetadataModel,
        exclusive: Bool
    ) {
        self.title = title
        self.excerpt = excerpt
        self.href = href
        self.imageURL = imageURL
        self.metadata = metadata
        self.exclusive = exclusive
    }
}

public struct AppPublicStyleAnchor: Component {
    public func html(context: inout BuilderContext) -> Div { Div {} }
}

public struct AppPublicTextBlock: Component {
    public let text: String

    public func html(context: inout BuilderContext) -> Div {
        Div { text }.class("public-body")
    }
}

public struct AppPublicBlogRouteSettings: Sendable {
    public let postListPath: String
    public let authorListPath: String
    public let tagListPath: String
    public let postPathPrefix: String
    public let authorPathPrefix: String
    public let tagPathPrefix: String

    init(schema: BlogAppAPI.Components.Schemas.BlogRouteSettingsSchema) {
        postListPath = schema.postListPath
        authorListPath = schema.authorListPath
        tagListPath = schema.tagListPath
        postPathPrefix = schema.postPathPrefix
        authorPathPrefix = schema.authorPathPrefix
        tagPathPrefix = schema.tagPathPrefix
    }
}

public struct AppPublicContentOpenAPIRepository: Sendable {
    public let api: BlogAppAPIClient

    init(api: BlogAppAPIClient) {
        self.api = api
    }

    func getRouteSettings() async throws
        -> BlogAppAPI.Components.Schemas.BlogRouteSettingsSchema
    {
        let response = try await api.client.blogRouteSettings(.init())
        switch response {
        case .ok(let value):
            return try value.body.json
        case .undocumented:
            throw CancellationError()
        }
    }
}
