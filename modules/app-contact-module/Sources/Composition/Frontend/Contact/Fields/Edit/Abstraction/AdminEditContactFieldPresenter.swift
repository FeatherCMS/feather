import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFieldPresenter: Sendable {
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
