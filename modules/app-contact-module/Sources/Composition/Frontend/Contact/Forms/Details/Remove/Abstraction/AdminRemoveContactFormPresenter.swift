import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormPresenter: Sendable {
    func renderConfirmation(id: String, name: String, permissions: Set<String>)
        -> HTMLResponse
    func renderConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
