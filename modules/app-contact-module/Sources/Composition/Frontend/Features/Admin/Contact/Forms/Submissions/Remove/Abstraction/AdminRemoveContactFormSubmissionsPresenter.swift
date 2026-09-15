import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormSubmissionsPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        item: AdminContactFormSubmissionItem,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
