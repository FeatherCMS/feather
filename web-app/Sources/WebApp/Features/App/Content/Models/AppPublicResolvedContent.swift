import AppOpenAPI

struct AppPublicResolvedContent: Sendable {
    let route: AppPublicResolvedRoute
    let siteSettings: Components.Schemas.WebSiteSettingsSchema
    let menus: Components.Schemas.WebMenuListSchema
}
