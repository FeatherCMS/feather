import Hummingbird

struct AppPublicContentDefaultPresenter: AppPublicContentPresenter {
    let themeRenderer: ThemeRenderer
    let themeContextFactory: ThemeContextFactory

    func render(
        content: AppPublicResolvedContent,
        request: Request
    ) -> HTMLResponse {
        let siteSettings = SiteSettingsModel(
            schema: content.siteSettings,
            publicOrigins: themeContextFactory.publicOrigins
        )
        let navigation = content.menus.first(where: { $0.key == "main" })?.items ?? []

        switch content.route {
        case .postList(let items, let routePaths):
            let model = AppGetBlogPostListModel(
                title: "Blog",
                items: items.map { routePaths.postSummaryModel(from: $0) }
            )
            return themeRenderer.render(
                themeContextFactory.makePostListContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .postDetail(let detail, let routePaths):
            let model = AppGetBlogPostModel(
                title: routePaths.displayTitle(from: detail.metadata),
                excerpt: routePaths.displayExcerpt(
                    metadata: detail.metadata,
                    fallback: detail.content
                ),
                imageURL: routePaths.nonEmpty(detail.imageURL),
                content: detail.content,
                publishedAt: routePaths.publicationLabel(from: detail.metadata),
                authors: detail.authors.map {
                    routePaths.authorSummaryModel(from: $0)
                },
                tags: detail.tags.map { routePaths.tagSummaryModel(from: $0) },
                metadata: routePaths.metadataModel(from: detail.metadata)
            )
            return themeRenderer.render(
                themeContextFactory.makePostDetailContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .authorList(let items, let routePaths):
            let model = AppGetBlogAuthorListModel(
                title: "Authors",
                items: items.map { routePaths.authorSummaryModel(from: $0) }
            )
            return themeRenderer.render(
                themeContextFactory.makeAuthorListContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .authorDetail(let detail, let routePaths):
            let model = AppGetBlogAuthorModel(
                title: detail.name,
                subtitle: routePaths.displayExcerpt(
                    metadata: detail.metadata,
                    fallback: detail.content
                ),
                imageURL: routePaths.nonEmpty(detail.imageURL),
                content: detail.content,
                links: detail.links.map(routePaths.authorLinkModel),
                posts: detail.posts.map {
                    routePaths.postSummaryModel(from: $0)
                },
                metadata: routePaths.metadataModel(from: detail.metadata)
            )
            return themeRenderer.render(
                themeContextFactory.makeAuthorDetailContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .tagList(let items, let routePaths):
            let model = AppGetBlogTagListModel(
                title: "Tags",
                items: items.map { routePaths.tagSummaryModel(from: $0) }
            )
            return themeRenderer.render(
                themeContextFactory.makeTagListContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .tagDetail(let detail, let routePaths):
            let model = AppGetBlogTagModel(
                title: routePaths.displayTitle(from: detail.metadata),
                excerpt: routePaths.displayExcerpt(
                    metadata: detail.metadata,
                    fallback: detail.content
                ),
                imageURL: routePaths.nonEmpty(detail.imageURL),
                content: detail.content,
                posts: detail.posts.map {
                    routePaths.postSummaryModel(from: $0)
                },
                metadata: routePaths.metadataModel(from: detail.metadata)
            )
            return themeRenderer.render(
                themeContextFactory.makeTagDetailContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )

        case .pageDetail(let detail, let routePaths):
            let model = AppGetWebPageModel(
                title: routePaths.displayTitle(from: detail.metadata),
                excerpt: routePaths.displayExcerpt(
                    metadata: detail.metadata,
                    fallback: detail.content
                ),
                imageURL: routePaths.nonEmpty(detail.imageURL),
                content: detail.content,
                metadata: routePaths.metadataModel(from: detail.metadata)
            )
            return themeRenderer.render(
                themeContextFactory.makePageContext(
                    request: request,
                    model: model,
                    siteSettings: siteSettings,
                    navigation: navigation,
                    siteNoIndex: routePaths.settings.siteNoIndex
                )
            )
        }
    }
}
