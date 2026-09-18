import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
