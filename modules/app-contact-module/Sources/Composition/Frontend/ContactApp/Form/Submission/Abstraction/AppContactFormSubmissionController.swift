import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AppContactFormSubmissionController: Sendable {
    func submit(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppContactFormSubmissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.post(ContactAppRoutes.submission, use: submit)
    }
}
