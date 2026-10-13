import FeatherAdmin
import MediaAdminAPI

protocol AdminListMediaVariantInteractor: Sendable {
    func listMediaVariants(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
    >
}
