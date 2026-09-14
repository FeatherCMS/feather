import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebPagePresenter: Sendable {

    func renderAddPage(
        state: WebPageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb() -> [NewAdminBreadcrumb.Link]
}
