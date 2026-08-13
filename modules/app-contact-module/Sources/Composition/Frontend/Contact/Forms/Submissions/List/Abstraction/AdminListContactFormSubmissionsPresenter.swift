import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormSubmissionsPresenter: Sendable {
    func renderList(
        formId: String,
        items: [AdminContactFormSubmissionItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
