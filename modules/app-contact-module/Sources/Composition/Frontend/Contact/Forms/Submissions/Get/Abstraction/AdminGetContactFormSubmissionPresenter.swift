import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetContactFormSubmissionPresenter: Sendable {
    func renderPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
