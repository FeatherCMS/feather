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
            slugPrefix: slugPrefix,
            publicationDate: .init(
                key: "md_publication_date",
                label: "Publication date & time",
                value: AdminMetadataDateDefaults.publicationDate(
                    metadata?.publicationDate
                ),
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
                label: "CSS code injection",
                value: metadata?.cssCodeInjection ?? "",
                error: nil
            ),
            javascriptCodeInjection: .init(
                key: "md_js",
                label: "JavaScript code injection",
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
