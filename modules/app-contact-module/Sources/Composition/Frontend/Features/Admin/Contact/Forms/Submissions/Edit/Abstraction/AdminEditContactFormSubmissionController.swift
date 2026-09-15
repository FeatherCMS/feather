import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormSubmissionController: Sendable {
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFormSubmissionController {
    func route(on router: Router<DefaultRequestContext>) {
        router.post(
            ContactAdminRoutes.formSubmissionEditRoute,
            use: update
        )
    }
}
