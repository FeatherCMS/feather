import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactSubmissionsPresenter: Sendable {
    func renderBulkConfirmation(selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
}
