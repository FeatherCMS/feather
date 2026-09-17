import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormPresenter: Sendable {
    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws -> HTMLResponse
}
