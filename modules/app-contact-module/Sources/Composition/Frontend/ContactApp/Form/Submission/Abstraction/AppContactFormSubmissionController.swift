import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

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
        router.post(
            "/contact/forms/:formId/submissions",
            use: submit
        )
    }
}
