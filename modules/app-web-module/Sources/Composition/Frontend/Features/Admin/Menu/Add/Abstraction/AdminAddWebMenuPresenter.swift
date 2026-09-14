import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuPresenter: Sendable {

    func renderAddPage(
        state: WebMenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb() -> [NewAdminBreadcrumb.Link]
}
