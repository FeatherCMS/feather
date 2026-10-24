import WebAppAPI

extension Public.Content {
    enum Repository {}
}

extension Public.Content.Repository {
    protocol Interface: Sendable {
        func resolveWebRoute(
            slug: String
        ) async throws -> Components.Schemas.MetadataSchema?

        func publicSiteSettings() async throws
            -> Components.Schemas.SiteSettingsSchema

        func publicMetadataSlugs() async throws -> [String]
    }
}
