import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormsPresenter: Sendable {
    func renderList(
        items: [AdminContactFormDetailsItem],
        search: String,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
