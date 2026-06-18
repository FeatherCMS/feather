import AppOpenAPI

protocol AppPublicContentRepository: Sendable {
    func getRouteSettings() async throws
        -> Components.Schemas.BlogRouteSettingsSchema
    func getSiteSettings() async throws
        -> Components.Schemas.WebSiteSettingsSchema
    func listMenus() async throws
        -> Components.Schemas.WebMenuListSchema
    func listBlogPosts() async throws
        -> Components.Schemas.BlogPostListSchema
    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.WebMetadataSchema?
    func getBlogPost(
        id: String
    ) async throws -> Components.Schemas.BlogPostDetailSchema?
    func listBlogAuthors() async throws
        -> Components.Schemas.BlogAuthorListSchema
    func getBlogAuthor(
        id: String
    ) async throws -> Components.Schemas.BlogAuthorDetailSchema?
    func listBlogTags() async throws
        -> Components.Schemas.BlogTagListSchema
    func getBlogTag(
        id: String
    ) async throws -> Components.Schemas.BlogTagDetailSchema?
    func getWebPage(
        id: String
    ) async throws -> Components.Schemas.WebPageDetailSchema?
}
