import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFieldPresenter: Sendable {
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
