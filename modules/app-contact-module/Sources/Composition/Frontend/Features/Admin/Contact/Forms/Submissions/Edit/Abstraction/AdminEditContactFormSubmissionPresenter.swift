import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormSubmissionPresenter: Sendable {
    func renderError(
        formId: String,
        id: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
