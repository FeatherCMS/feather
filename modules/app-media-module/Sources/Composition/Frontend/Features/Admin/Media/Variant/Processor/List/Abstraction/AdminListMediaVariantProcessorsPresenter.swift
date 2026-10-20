import FeatherWebAdmin
import Hummingbird
import MediaAdminAPI

protocol AdminListMediaVariantProcessorsPresenter: Sendable {
    func renderListPage(
        variantId: String,
        model: AdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
        >,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderAddPage(variantId: String) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListMediaVariantProcessorsError)
        async throws -> HTMLResponse
}
