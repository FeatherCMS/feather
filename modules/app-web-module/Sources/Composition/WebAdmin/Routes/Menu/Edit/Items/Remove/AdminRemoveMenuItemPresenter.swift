import FeatherWebAdmin
import WebDomain
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: WebDomain.Menu.Item.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: WebDomain.Menu.Item.Routes.RemoveOrigin
    ) async throws -> HTMLResponse

}
