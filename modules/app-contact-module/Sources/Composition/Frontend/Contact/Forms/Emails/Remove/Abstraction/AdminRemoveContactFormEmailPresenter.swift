import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormEmailPresenter: Sendable {
    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
