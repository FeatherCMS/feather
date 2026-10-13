import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormPresenter: Sendable {
    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderEditError(
        key: String,
        item: AdminContactFormDetailsItem,
        error: AdminEditContactFormError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminEditContactFormError
    ) async throws -> HTMLResponse
}
