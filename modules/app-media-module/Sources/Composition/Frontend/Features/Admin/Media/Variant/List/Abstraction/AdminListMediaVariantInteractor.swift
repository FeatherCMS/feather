import FeatherWebAdmin
import MediaAdminAPI

protocol AdminListMediaVariantInteractor: Sendable {
    func listMediaVariants(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<
        MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
    >
}
