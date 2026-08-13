import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFormPresenter: Sendable {
    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
