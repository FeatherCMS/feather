import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddContactFormFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
