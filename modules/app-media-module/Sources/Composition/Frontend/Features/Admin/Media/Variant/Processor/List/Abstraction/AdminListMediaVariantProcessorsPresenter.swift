import FeatherAdmin
import Hummingbird
import MediaAdminAPI

protocol AdminListMediaVariantProcessorsPresenter: Sendable {
    func renderListPage(
        variantId: String,
        model: NewAdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderAddPage(variantId: String) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListMediaVariantProcessorsError)
        async throws -> HTMLResponse
}
