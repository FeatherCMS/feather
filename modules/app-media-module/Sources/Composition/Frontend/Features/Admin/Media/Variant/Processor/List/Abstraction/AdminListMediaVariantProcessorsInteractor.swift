import FeatherAdmin
import MediaAdminAPI

protocol AdminListMediaVariantProcessorsInteractor: Sendable {
    func list(
        variantId: String,
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema>
}
