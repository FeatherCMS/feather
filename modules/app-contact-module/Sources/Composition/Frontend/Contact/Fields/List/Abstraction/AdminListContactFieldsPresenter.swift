import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFieldsPresenter: Sendable {
    func renderList(
        fields: [AdminContactFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
