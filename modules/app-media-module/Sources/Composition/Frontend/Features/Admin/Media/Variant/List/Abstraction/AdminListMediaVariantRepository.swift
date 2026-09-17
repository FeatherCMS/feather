import MediaAdminAPI

protocol AdminListMediaVariantRepository: Sendable {
    func listMediaVariants(
        page: Int,
        search: String?
    ) async throws
        -> MediaAdminAPI.Components.Responses
        .MediaVariantListItemSearchSchemaSearchResponse
}
