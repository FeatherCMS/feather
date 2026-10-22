import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

protocol AdminRemoveMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: WebModule.Menu.Item.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: WebModule.Menu.Item.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

}
