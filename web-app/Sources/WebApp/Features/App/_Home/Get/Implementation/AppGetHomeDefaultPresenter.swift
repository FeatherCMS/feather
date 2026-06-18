import Hummingbird

struct AppGetHomeDefaultPresenter: AppGetHomePresenter {
    let request: Request
    let themeRenderer: ThemeRenderer
    let themeContextFactory: ThemeContextFactory

    func renderPage(
        model: AppGetHomeModel
    ) -> HTMLResponse {
        switch model {
        case .page(let content):
            return AppPublicContentDefaultPresenter(
                themeRenderer: themeRenderer,
                themeContextFactory: themeContextFactory
            )
            .render(content: content, request: request)
        case .defaultHome(
            let siteSettingsSchema,
            let menus,
            let posts,
            let routeSettings
        ):
            let siteSettings = SiteSettingsModel(
                schema: siteSettingsSchema,
                publicOrigins: themeContextFactory.publicOrigins
            )
            let navigation = menus.first(where: { $0.key == "main" })?.items ?? []
            let routePaths = AppPublicRoutePaths(
                settings: .init(schema: routeSettings)
            )
            let items = routePaths.map { paths in
                posts.map { paths.postSummaryModel(from: $0) }
            } ?? []

            return themeRenderer.render(
                themeContextFactory.makeHomeContext(
                    request: request,
                    posts: items,
                    siteSettings: siteSettings,
                    navigation: navigation
                )
            )
        }
    }
}
