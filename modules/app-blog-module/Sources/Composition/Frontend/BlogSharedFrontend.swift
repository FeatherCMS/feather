import BlogAdminAPI
import BlogAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebFrontend
import WebStandards

extension AdminMediaAssetOpenAPIRepository {
    init(api: BlogAdminAPIClient) {
        self.init(
            api: MediaAdminAPIClient(
                apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
                sessionToken: api.sessionToken
            )
        )
    }
}

struct AdminMetadataFields: Component, FlowContent {
    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var slug: FieldState
        var template: FieldState
        var slugPrefix: String?
        var publicationDate: FieldState
        var expirationDate: FieldState
        var status: FieldState
        var title: FieldState
        var excerpt: FieldState
        var imageUrl: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var canonicalUrl: FieldState
        var noIndex: CheckboxState
        var primaryKeyword: FieldState
        var cssCodeInjection: FieldState
        var javascriptCodeInjection: FieldState
        var structuredDataCodeInjection: FieldState

        mutating func apply(errors: [String: String]) {
            slug.error = errors[slug.key]
            template.error = errors[template.key]
            publicationDate.error = errors[publicationDate.key]
            expirationDate.error = errors[expirationDate.key]
            status.error = errors[status.key]
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            imageUrl.error = errors[imageUrl.key]
            canonicalUrl.error = errors[canonicalUrl.key]
            noIndex.error = errors[noIndex.key]
            primaryKeyword.error = errors[primaryKeyword.key]
            cssCodeInjection.error = errors[cssCodeInjection.key]
            javascriptCodeInjection.error = errors[javascriptCodeInjection.key]
            structuredDataCodeInjection.error =
                errors[structuredDataCodeInjection.key]
        }
    }

    var state: State
    var showTitle: Bool
    var showTemplate: Bool = false
    var titleRequired: Bool = false

    func content() -> some BasicTag {
        Div {
            FormInputField(
                name: state.slug.key,
                label: state.slug.label,
                prefix: state.slugPrefix,
                value: state.slug.value,
                error: state.slug.error,
                isRequired: true
            )
            if showTemplate {
                FormSelectField(
                    name: state.template.key,
                    label: state.template.label,
                    options: [.init(label: "Default", value: "default")],
                    selectedValue: state.template.value,
                    error: state.template.error,
                    isRequired: true
                )
            }
            Div {
                H3("Publishing")
                FormSelectField(
                    name: state.status.key,
                    label: state.status.label,
                    options: ["draft", "published", "archived"]
                        .map {
                            .init(label: $0.capitalized, value: $0)
                        },
                    selectedValue: state.status.value,
                    error: state.status.error,
                    isRequired: true
                )
                FormDateTimeField(
                    name: state.publicationDate.key,
                    label: state.publicationDate.label,
                    value: state.publicationDate.value,
                    error: state.publicationDate.error
                )
                FormDateTimeField(
                    name: state.expirationDate.key,
                    label: state.expirationDate.label,
                    value: state.expirationDate.value,
                    error: state.expirationDate.error
                )
            }
            .class("admin-metadata-fields__group")

            Div {
                H3("Social")
                Div {
                    if showTitle {
                        FormInputField(
                            name: state.title.key,
                            label: state.title.label,
                            value: state.title.value,
                            error: state.title.error,
                            isRequired: titleRequired
                        )
                    }
                    FormTextAreaField(
                        name: state.excerpt.key,
                        label: state.excerpt.label,
                        value: state.excerpt.value,
                        error: state.excerpt.error,
                        rows: 4
                    )
                    AdminMediaAssetPicker(
                        state: .init(
                            field: .init(
                                key: state.imageUrl.key,
                                label: state.imageUrl.label,
                                value: state.imageUrl.value,
                                error: state.imageUrl.error
                            ),
                            selectedAsset: state.selectedImageAsset,
                            browsePath:
                                "/admin/media/assets/?picker=1&field=\(state.imageUrl.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                            allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                            outputMode: .originalURL
                        )
                    )
                }
                .class("admin-metadata-fields__group")
            }
            .class("admin-metadata-fields__section")

            Div {
                H3("Advanced")
                Div {
                    FormInputField(
                        name: state.canonicalUrl.key,
                        label: state.canonicalUrl.label,
                        value: state.canonicalUrl.value,
                        error: state.canonicalUrl.error
                    )
                    CheckboxField(
                        state: .init(
                            key: state.noIndex.key,
                            label: state.noIndex.label,
                            value: state.noIndex.value,
                            error: state.noIndex.error
                        )
                    )
                    FormInputField(
                        name: state.primaryKeyword.key,
                        label: state.primaryKeyword.label,
                        value: state.primaryKeyword.value,
                        error: state.primaryKeyword.error
                    )
                    FormTextAreaField(
                        name: state.cssCodeInjection.key,
                        label: state.cssCodeInjection.label,
                        value: state.cssCodeInjection.value,
                        error: state.cssCodeInjection.error,
                        rows: 10
                    )
                    FormTextAreaField(
                        name: state.javascriptCodeInjection.key,
                        label: state.javascriptCodeInjection.label,
                        value: state.javascriptCodeInjection.value,
                        error: state.javascriptCodeInjection.error,
                        rows: 10
                    )
                    FormTextAreaField(
                        name: state.structuredDataCodeInjection.key,
                        label: state.structuredDataCodeInjection.label,
                        value: state.structuredDataCodeInjection.value,
                        error: state.structuredDataCodeInjection.error,
                        rows: 10
                    )
                }
                .class("admin-metadata-fields__group")
            }
            .class("admin-metadata-fields__section")
        }
        .class("admin-metadata-fields")
    }
}

struct AdminMetadataFieldStateFactory {
    static func make(
        _ metadata: AdminMetadataFormValue?,
        slugPrefix: String? = nil
    ) -> AdminMetadataFields.State {
        .init(
            slug: .init(
                key: "md_slug",
                label: "Slug",
                value: metadata?.slug ?? "",
                error: nil
            ),
            template: .init(
                key: "md_template",
                label: "Template",
                value: metadata?.template ?? "default",
                error: nil
            ),
            slugPrefix: slugPrefix,
            publicationDate: .init(
                key: "md_publication_date",
                label: "Publication date & time",
                value: metadata?.publicationDate ?? "",
                error: nil
            ),
            expirationDate: .init(
                key: "md_expiration_date",
                label: "Expiration date & time",
                value: metadata?.expirationDate ?? "",
                error: nil
            ),
            status: .init(
                key: "md_status",
                label: "Status",
                value: metadata?.status ?? "draft",
                error: nil
            ),
            title: .init(
                key: "md_title",
                label: "Title",
                value: metadata?.title ?? "",
                error: nil
            ),
            excerpt: .init(
                key: "md_excerpt",
                label: "Excerpt",
                value: metadata?.excerpt ?? "",
                error: nil
            ),
            imageUrl: .init(
                key: "md_image_url",
                label: "Image URL",
                value: metadata?.imageUrl ?? "",
                error: nil
            ),
            selectedImageAsset: AdminMediaAssetReferenceModel.metadataImageURL(
                metadata?.imageUrl
            ),
            canonicalUrl: .init(
                key: "md_canonical_url",
                label: "Canonical URL",
                value: metadata?.canonicalUrl ?? "",
                error: nil
            ),
            noIndex: .init(
                key: "md_no_index",
                label: "No index",
                value: metadata?.noIndex ?? false,
                error: nil
            ),
            primaryKeyword: .init(
                key: "md_primary_keyword",
                label: "Primary keyword",
                value: metadata?.primaryKeyword ?? "",
                error: nil
            ),
            cssCodeInjection: .init(
                key: "md_css",
                label: "CSS",
                value: metadata?.cssCodeInjection ?? "",
                error: nil
            ),
            javascriptCodeInjection: .init(
                key: "md_js",
                label: "JavaScript",
                value: metadata?.javascriptCodeInjection ?? "",
                error: nil
            ),
            structuredDataCodeInjection: .init(
                key: "md_structured_data",
                label: "Structured data",
                value: metadata?.structuredDataCodeInjection ?? "",
                error: nil
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

public struct AppPublicStyleAnchor: Component, FlowContent {
    public func content() -> some BasicTag { Div {} }
}

public struct AppPublicTextBlock: Component, FlowContent {
    public let text: String

    public func content() -> some BasicTag {
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
