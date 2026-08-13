import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormSubmissionsPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        item: AdminContactFormSubmissionItem,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
