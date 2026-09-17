import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFieldPresenter: Sendable {
    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws -> HTMLResponse

    func renderForbiddenPage() async throws -> HTMLResponse
}
