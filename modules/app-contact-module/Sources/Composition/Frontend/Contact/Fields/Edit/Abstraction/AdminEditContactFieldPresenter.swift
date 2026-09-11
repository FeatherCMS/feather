import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFieldPresenter: Sendable {
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
