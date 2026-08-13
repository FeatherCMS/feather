import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFieldPresenter: Sendable {
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
