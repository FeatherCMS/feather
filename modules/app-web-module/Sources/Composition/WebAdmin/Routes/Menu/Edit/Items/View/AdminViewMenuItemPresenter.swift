import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewMenuItemPresenter: Sendable {

    func renderDetailsPage(
        rule: MenuItemDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
