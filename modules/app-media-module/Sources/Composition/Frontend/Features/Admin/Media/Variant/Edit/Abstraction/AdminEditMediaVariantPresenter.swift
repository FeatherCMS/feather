import FeatherAdmin
import Hummingbird
import MediaAdminAPI

protocol AdminEditMediaVariantPresenter: Sendable {
    func renderEditPage(id: String, detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema, state: MediaVariantFormView.State, permissions: NewAdminListActions) async throws -> HTMLResponse
    func renderErrorPage(error: AdminEditMediaVariantError) async throws -> HTMLResponse
    func renderSuccess(id: String) -> Response
}
