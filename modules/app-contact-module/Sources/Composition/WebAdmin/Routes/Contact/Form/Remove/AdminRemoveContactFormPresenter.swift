import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormPresenter: Sendable {
    func renderRemovePage(items: [AdminRemoveItemContext])
        async throws -> HTMLResponse
}
