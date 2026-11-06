extension Public.Content {
    enum Interactor {}
}

extension Public.Content.Interactor {
    protocol Interface: Sendable {
        func resolve(slug: String) async throws -> Public.Content.Model

        func resolveRSS() async throws -> Public.RSS.Model

        func resolveSitemap() async throws -> Public.Sitemap.Model
    }
}
