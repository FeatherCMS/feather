import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormPresenter: Sendable {
    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
