import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormsPresenter: Sendable {
    func renderList(
        items: [AdminContactFormDetailsItem],
        search: String,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
