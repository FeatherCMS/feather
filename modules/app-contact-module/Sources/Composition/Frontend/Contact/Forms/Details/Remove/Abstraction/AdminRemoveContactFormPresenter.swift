import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormPresenter: Sendable {
    func renderConfirmation(id: String, name: String, permissions: Set<String>)
        -> HTMLResponse
    func renderBulkConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
