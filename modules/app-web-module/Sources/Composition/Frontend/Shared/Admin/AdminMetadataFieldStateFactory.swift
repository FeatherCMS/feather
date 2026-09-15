import FeatherAdmin
import OpenAPIRuntime

public struct AdminMetadataFieldStateFactory {
    public static func make(
        _ metadata: AdminMetadataFormValue?,
        slugPrefix: String? = nil,
        template: String = "default"
    ) -> AdminMetadataFields.State {
        .init(
            slug: .init(
                key: "slug",
                label: "Slug",
                value: metadata?.slug ?? "",
                error: nil
            ),
            template: .init(
                key: "template",
                label: "Template",
                value: metadata?.template ?? template,
                error: nil
            ),
            slugPrefix: slugPrefix,
            publicationDate: .init(
                key: "publicationDate",
                label: "Publication date & time",
                value: AdminMetadataDateDefaults.publicationDate(
                    metadata?.publicationDate
                ),
                error: nil
            ),
            expirationDate: .init(
                key: "expirationDate",
                label: "Expiration date & time",
                value: metadata?.expirationDate ?? "",
                error: nil
            ),
            status: .init(
                key: "status",
                label: "Status",
                value: metadata?.status ?? "draft",
                error: nil
            ),
            title: .init(
                key: "title",
                label: "Title",
                value: metadata?.title ?? "",
                error: nil
            ),
            excerpt: .init(
                key: "excerpt",
                label: "Excerpt",
                value: metadata?.excerpt ?? "",
                error: nil
            ),
            imageUrl: .init(
                key: "imageUrl",
                label: "Image",
                value: metadata?.imageUrl ?? "",
                error: nil
            ),
            selectedImageAsset: AdminMediaAssetReferenceModel.metadataImageURL(
                metadata?.imageUrl
            ),
            canonicalUrl: .init(
                key: "canonicalUrl",
                label: "Canonical URL",
                value: metadata?.canonicalUrl ?? "",
                error: nil
            ),
            noIndex: .init(
                key: "noIndex",
                label: "No index",
                value: metadata?.noIndex ?? false,
                error: nil
            ),
            primaryKeyword: .init(
                key: "primaryKeyword",
                label: "Primary keyword",
                value: metadata?.primaryKeyword ?? "",
                error: nil
            ),
            cssCodeInjection: .init(
                key: "cssCodeInjection",
                label: "CSS code injection",
                value: metadata?.cssCodeInjection ?? "",
                error: nil
            ),
            javascriptCodeInjection: .init(
                key: "javascriptCodeInjection",
                label: "JavaScript code injection",
                value: metadata?.javascriptCodeInjection ?? "",
                error: nil
            ),
            structuredDataCodeInjection: .init(
                key: "structuredDataCodeInjection",
                label: "Structured data",
                value: metadata?.structuredDataCodeInjection ?? "",
                error: nil
            )
        )
    }
}
