import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFormSubmissionController: Sendable {
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFormSubmissionController {
    func route(on router: Router<DefaultRequestContext>) {
        router.post(
            "/admin/contact/forms/:formId/submissions/:submissionId/",
            use: update
        )
    }
}
