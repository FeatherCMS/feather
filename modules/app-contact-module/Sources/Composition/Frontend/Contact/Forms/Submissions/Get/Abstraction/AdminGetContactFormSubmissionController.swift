import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetContactFormSubmissionController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetContactFormSubmissionController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/submissions/:submissionId/",
            use: get
        )
    }
}
