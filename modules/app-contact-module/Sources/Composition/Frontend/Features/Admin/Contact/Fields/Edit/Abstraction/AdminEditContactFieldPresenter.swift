import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFieldPresenter: Sendable {
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        fieldErrors: [String: String],
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderEditError(
        field: AdminContactFieldRow,
        error: AdminEditContactFieldError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminEditContactFieldError
    ) async throws -> HTMLResponse

    func renderForbiddenPage() async throws -> HTMLResponse
}
