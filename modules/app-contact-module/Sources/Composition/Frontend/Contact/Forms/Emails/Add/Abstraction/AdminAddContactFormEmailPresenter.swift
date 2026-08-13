import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddContactFormEmailPresenter: Sendable {
    func renderPage(
        formId: String,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
