import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewWebMenuPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
