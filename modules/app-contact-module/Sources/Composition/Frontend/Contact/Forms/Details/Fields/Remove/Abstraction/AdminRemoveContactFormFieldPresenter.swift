import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormFieldPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    )
        -> HTMLResponse
}
