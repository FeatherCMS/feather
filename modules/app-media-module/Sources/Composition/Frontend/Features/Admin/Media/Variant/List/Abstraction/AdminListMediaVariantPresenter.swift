import FeatherAdmin
import Hummingbird
import MediaAdminAPI

protocol AdminListMediaVariantPresenter: Sendable {
    func renderListPage(
        model: AdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
        >,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListMediaVariantError) async throws
        -> HTMLResponse
}
