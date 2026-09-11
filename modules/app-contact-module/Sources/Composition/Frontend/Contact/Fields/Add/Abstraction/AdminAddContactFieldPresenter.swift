import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
