import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFieldsPresenter: Sendable {
    func renderList(
        fields: [AdminContactFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderForbiddenPage() async throws -> HTMLResponse
}
