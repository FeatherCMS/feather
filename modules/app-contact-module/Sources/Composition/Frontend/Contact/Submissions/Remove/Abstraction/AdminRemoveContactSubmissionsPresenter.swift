import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactSubmissionsPresenter: Sendable {
    func renderConfirmation(selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
}
