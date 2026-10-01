protocol AppPublicContentInteractor: Sendable {

    func resolve(
        slug: String
    ) async throws -> AppPublicContentModel

    func resolveRSS() async throws -> AppPublicRSSModel

    func resolveSitemap() async throws -> AppPublicSitemapModel
}
