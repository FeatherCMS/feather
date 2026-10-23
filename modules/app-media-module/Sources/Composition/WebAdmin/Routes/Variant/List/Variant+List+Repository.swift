import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.List {
    enum Repository {}
}

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
