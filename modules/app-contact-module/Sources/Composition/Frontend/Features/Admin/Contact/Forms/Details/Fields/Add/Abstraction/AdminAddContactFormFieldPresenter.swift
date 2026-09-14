import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
