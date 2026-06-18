import Hummingbird

struct AppGetHomeDefaultInteractor: AppGetHomeInteractor {
    let repository: any AppPublicContentRepository

    func getHome(
        account: AccountModel?
    ) async throws -> AppGetHomeModel {
        async let siteSettings = repository.getSiteSettings()
        async let menus = repository.listMenus()
        async let routeSettings = repository.getRouteSettings()

        let resolvedSiteSettings = try await siteSettings
        let resolvedMenus = try await menus
        let resolvedRouteSettings = try await routeSettings

        if
            let homePageId = resolvedSiteSettings.homePageId?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !homePageId.isEmpty,
            let detail = try await repository.getWebPage(id: homePageId),
            let routePaths = AppPublicRoutePaths(
                settings: .init(schema: resolvedRouteSettings)
            )
        {
            return .page(
                .init(
                    route: .pageDetail(detail: detail, routePaths: routePaths),
                    siteSettings: resolvedSiteSettings,
                    menus: resolvedMenus
                )
            )
        }

        let posts = try await repository.listBlogPosts()
        return .defaultHome(
            siteSettings: resolvedSiteSettings,
            menus: resolvedMenus,
            posts: posts,
            routeSettings: resolvedRouteSettings
        )
    }
}
