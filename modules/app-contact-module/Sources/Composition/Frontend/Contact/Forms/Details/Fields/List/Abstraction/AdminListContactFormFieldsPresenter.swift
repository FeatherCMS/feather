import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormFieldsPresenter: Sendable {
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
