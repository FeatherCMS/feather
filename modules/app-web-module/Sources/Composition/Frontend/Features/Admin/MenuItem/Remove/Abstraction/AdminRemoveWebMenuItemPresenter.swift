import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemPresenter: Sendable {

    func renderRemovePage(
        menuId: String,
        id: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State
}
