import FeatherAdmin
import Hummingbird
import MediaAdminAPI

protocol AdminListMediaVariantPresenter: Sendable {
    func renderListPage(
        model: NewAdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListMediaVariantError) async throws
        -> HTMLResponse
}
