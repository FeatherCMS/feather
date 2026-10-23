import ContactModule
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormSubmissionsPresenter: Sendable {
    func renderList(
        formId: String,
        items: [Submission.Item],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
