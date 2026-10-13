import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewWebPagePresenter: Sendable {

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

}
