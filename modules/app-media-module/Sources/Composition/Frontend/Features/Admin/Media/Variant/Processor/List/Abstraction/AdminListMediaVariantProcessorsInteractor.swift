import FeatherWebAdmin
import MediaAdminAPI

protocol AdminListMediaVariantProcessorsInteractor: Sendable {
    func list(
        variantId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListModel<
        MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    >
}
