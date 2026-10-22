import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminViewMenuPresenter: Sendable {

    func renderDetailsPage(
        rule: MenuDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
