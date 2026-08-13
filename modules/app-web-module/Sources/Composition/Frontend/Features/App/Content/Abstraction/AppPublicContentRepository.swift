import WebAppAPI

public protocol AppPublicContentRepository: Sendable {
    typealias WebComponents = WebAppAPI.Components

    func resolveWebRoute(
        slug: String
    ) async throws -> WebComponents.Schemas.WebMetadataSchema?

    func withSessionToken(
        _ sessionToken: String?
    ) -> any AppPublicContentRepository
}
