import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddContactFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
