public import WebAppAPI

public protocol AppPublicContentRepository: Sendable {

    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.MetadataSchema?

    func publicSiteSettings() async throws
        -> Components.Schemas.SiteSettingsSchema

    func publicMetadataSlugs() async throws -> [String]
}
