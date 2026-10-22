import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewPagePresenter: Sendable {

    func renderDetailsPage(
        rule: PageDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

}
