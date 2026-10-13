import MediaAdminAPI

protocol AdminListMediaVariantProcessorsRepository: Sendable {
    func list(
        variantId: String,
        page: Int,
        search: String?
    ) async throws
        -> MediaAdminAPI.Components.Responses
        .MediaVariantProcessorListItemSearchSchemaSearchResponse
}
