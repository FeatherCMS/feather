import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

protocol AdminRemoveMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: Menu.Router.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: Menu.Router.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

}
