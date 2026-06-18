import AppOpenAPI

enum AppPublicResolvedRoute: Sendable {
    case postList(
        items: Components.Schemas.BlogPostListSchema,
        routePaths: AppPublicRoutePaths
    )
    case postDetail(
        detail: Components.Schemas.BlogPostDetailSchema,
        routePaths: AppPublicRoutePaths
    )
    case authorList(
        items: Components.Schemas.BlogAuthorListSchema,
        routePaths: AppPublicRoutePaths
    )
    case authorDetail(
        detail: Components.Schemas.BlogAuthorDetailSchema,
        routePaths: AppPublicRoutePaths
    )
    case tagList(
        items: Components.Schemas.BlogTagListSchema,
        routePaths: AppPublicRoutePaths
    )
    case tagDetail(
        detail: Components.Schemas.BlogTagDetailSchema,
        routePaths: AppPublicRoutePaths
    )
    case pageDetail(
        detail: Components.Schemas.WebPageDetailSchema,
        routePaths: AppPublicRoutePaths
    )
}
