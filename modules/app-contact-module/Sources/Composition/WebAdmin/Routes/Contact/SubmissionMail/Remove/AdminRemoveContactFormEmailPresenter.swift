import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormEmailPresenter: Sendable {
    func renderRemovePage(
        formId: String,
        items: [AdminRemoveItemContext]
    ) async throws -> HTMLResponse
}
