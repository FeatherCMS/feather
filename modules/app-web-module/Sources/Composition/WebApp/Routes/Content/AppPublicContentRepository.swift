public import WebAppAPI

public protocol AppPublicContentRepository: Sendable {

    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.WebMetadataSchema?

    func publicSiteSettings() async throws
        -> Components.Schemas.WebSiteSettingsSchema

    func publicMetadataSlugs() async throws -> [String]
}
