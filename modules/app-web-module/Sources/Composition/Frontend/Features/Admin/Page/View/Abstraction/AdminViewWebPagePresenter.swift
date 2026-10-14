import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewWebPagePresenter: Sendable {

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

}
