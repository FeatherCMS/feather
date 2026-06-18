import AppOpenAPI

enum AppGetHomeModel: Sendable {
    case page(AppPublicResolvedContent)
    case defaultHome(
        siteSettings: Components.Schemas.WebSiteSettingsSchema,
        menus: Components.Schemas.WebMenuListSchema,
        posts: Components.Schemas.BlogPostListSchema,
        routeSettings: Components.Schemas.BlogRouteSettingsSchema
    )
}
