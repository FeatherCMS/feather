import FeatherWebAdmin
import MediaAdminAPI
import MediaModule

extension Variant.List.Interactor {
    protocol Interface: Sendable {
        func listMediaVariants(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
        >
    }
}
