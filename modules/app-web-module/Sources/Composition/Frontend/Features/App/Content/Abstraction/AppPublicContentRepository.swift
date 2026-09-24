public import WebAppAPI

public protocol AppPublicContentRepository: Sendable {

    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.WebMetadataSchema?
}
