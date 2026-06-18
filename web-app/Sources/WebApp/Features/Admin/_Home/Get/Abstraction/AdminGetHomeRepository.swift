import AdminOpenAPI

protocol AdminGetHomeRepository: Sendable {
    func blogPostsTotal() async throws -> Int
    func blogAuthorsTotal() async throws -> Int
    func blogTagsTotal() async throws -> Int
    func webPagesTotal() async throws -> Int
    func webMenusTotal() async throws -> Int
    func redirectRulesTotal() async throws -> Int
    func webOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
