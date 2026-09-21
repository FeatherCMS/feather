import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: NewAdminRemoveItemContext,
        origin: WebMenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: WebMenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse

}
