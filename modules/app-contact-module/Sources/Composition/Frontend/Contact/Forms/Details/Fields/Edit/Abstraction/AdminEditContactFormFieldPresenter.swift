import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFormFieldPresenter: Sendable {
    func renderPage(
        formId: String,
        field: AdminContactFormFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
