import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddContactFormFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
