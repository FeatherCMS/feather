import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebComponents

protocol AdminRemoveMediaVariantPresenter: Sendable {
    func renderRemovePage(items: [NewAdminRemoveItemContext], returnTo: String?)
        async throws -> HTMLResponse
    func renderErrorPage(error: AdminRemoveMediaVariantError, cancel: String)
        async throws -> HTMLResponse
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
    func renderSuccess(location: String, count: Int) -> Response
}
