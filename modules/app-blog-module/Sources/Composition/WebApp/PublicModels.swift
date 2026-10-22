public import HTML
import WebBuilders
public import WebComponents
public import WebModuleWebApp

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
