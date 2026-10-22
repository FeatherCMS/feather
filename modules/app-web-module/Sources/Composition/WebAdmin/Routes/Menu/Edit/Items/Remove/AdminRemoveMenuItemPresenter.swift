import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: MenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: MenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse

}
