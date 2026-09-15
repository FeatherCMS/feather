import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFieldPresenter: Sendable {
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderForbiddenPage() async throws -> HTMLResponse
}
