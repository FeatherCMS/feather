import AppOpenAPI

struct AppPublicRoutePaths: Sendable {
    enum Kind: Sendable {
        case post
        case author
        case tag
    }

    struct PrefixedKind: Sendable {
        let prefix: String
        let kind: Kind
    }

    static let reservedTopLevelPaths: Set<String> = [
        "admin",
        "health",
        "login",
        "logout",
        "style.css",
        "admin-navigation.js",
    ]

    let settings: AppPublicBlogRouteSettings
    let detailPrefixKinds: [PrefixedKind]

    init?(settings: AppPublicBlogRouteSettings) {
        let listPaths = [
            settings.postListPath,
            settings.authorListPath,
            settings.tagListPath,
        ]
        guard listPaths.allSatisfy({ !$0.isEmpty }) else {
            return nil
        }
        guard Set(listPaths).count == listPaths.count else {
            return nil
        }
        guard listPaths.allSatisfy({ !Self.reservedTopLevelPaths.contains($0) })
        else {
            return nil
        }

        let detailPrefixKinds = [
            PrefixedKind(prefix: settings.postPathPrefix, kind: .post),
            PrefixedKind(prefix: settings.authorPathPrefix, kind: .author),
            PrefixedKind(prefix: settings.tagPathPrefix, kind: .tag),
        ]
        let nonEmptyPrefixes =
            detailPrefixKinds
            .map(\.prefix)
            .filter { !$0.isEmpty }
        guard Set(nonEmptyPrefixes).count == nonEmptyPrefixes.count else {
            return nil
        }

        self.settings = settings
        self.detailPrefixKinds = detailPrefixKinds
    }
}

extension AppPublicRoutePaths {
    func metadataModel(
        from metadata: Components.Schemas.WebMetadataContentSchema
    ) -> AppPublicMetadataModel {
        .init(schema: metadata)
    }

    func postSummaryModel(
        from item: Components.Schemas.BlogPostSummarySchema
    ) -> AppPublicPostSummaryModel {
        let metadata = metadataModel(from: item.metadata)
        return .init(
            title: displayTitle(from: item.metadata),
            excerpt: displayExcerpt(metadata: item.metadata, fallback: ""),
            href: postDetailPath(slug: item.metadata.slug),
            publishedAt: publicationLabel(from: item.metadata),
            metadata: metadata
        )
    }

    func authorSummaryModel(
        from item: Components.Schemas.BlogAuthorSummarySchema
    ) -> AppPublicAuthorSummaryModel {
        let metadata = metadataModel(from: item.metadata)
        return .init(
            name: item.name,
            excerpt: displayExcerpt(
                metadata: item.metadata,
                fallback: item.content
            ),
            href: authorDetailPath(slug: item.metadata.slug),
            imageURL: nonEmpty(item.media?.defaultURL ?? "") ?? nonEmpty(item.imageURL),
            metadata: metadata
        )
    }

    func tagSummaryModel(
        from item: Components.Schemas.BlogTagSummarySchema
    ) -> AppPublicTagSummaryModel {
        let metadata = metadataModel(from: item.metadata)
        return .init(
            title: displayTitle(from: item.metadata),
            excerpt: displayExcerpt(metadata: item.metadata, fallback: ""),
            href: tagDetailPath(slug: item.metadata.slug),
            metadata: metadata
        )
    }

    func authorLinkModel(
        from item: Components.Schemas.BlogAuthorLinkSchema
    ) -> AppPublicAuthorLinkModel {
        .init(label: item.label, url: item.url, isBlank: item.isBlank)
    }

    func displayTitle(
        from metadata: Components.Schemas.WebMetadataContentSchema
    ) -> String {
        metadata.title.isEmpty ? metadata.slug : metadata.title
    }

    func displayExcerpt(
        metadata: Components.Schemas.WebMetadataContentSchema,
        fallback: String
    ) -> String {
        let candidate = nonEmpty(metadata.excerpt) ?? nonEmpty(fallback) ?? ""
        return String(candidate.prefix(220))
    }

    func publicationLabel(
        from metadata: Components.Schemas.WebMetadataContentSchema
    ) -> String? {
        guard let publicationDate = metadata.publicationDate else {
            return nil
        }
        return DateFormatting.formatUnixTimestamp(publicationDate)
    }

    func postDetailPath(
        slug: String
    ) -> String {
        detailPath(slug: slug)
    }

    func authorDetailPath(
        slug: String
    ) -> String {
        detailPath(slug: slug)
    }

    func tagDetailPath(
        slug: String
    ) -> String {
        detailPath(slug: slug)
    }

    func nonEmpty(
        _ value: String
    ) -> String? {
        value.isEmpty ? nil : value
    }
}

extension AppPublicRoutePaths {
    fileprivate func detailPath(
        slug: String
    ) -> String {
        "/\(slug)/"
    }
}
