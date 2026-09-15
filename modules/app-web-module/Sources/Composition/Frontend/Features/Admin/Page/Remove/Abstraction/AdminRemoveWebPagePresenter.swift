import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebPagePresenter: Sendable {

    func renderRemovePage(
        id: String,
        source: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
