import MediaAdminAPI
import MediaModule

extension Variant.List.Repository {
    protocol Interface: Sendable {
        func listMediaVariants(
            page: Int,
            search: String?
        ) async throws
            -> MediaAdminAPI.Components.Responses
            .MediaVariantQueryItemSearchSchemaSearchResponse
    }
}
