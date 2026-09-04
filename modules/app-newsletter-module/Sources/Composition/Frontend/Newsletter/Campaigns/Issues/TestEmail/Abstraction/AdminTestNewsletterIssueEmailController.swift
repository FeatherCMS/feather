import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminTestNewsletterIssueEmailController: Sendable {
    func send(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminTestNewsletterIssueEmailController {
    func route(on router: Router<DefaultRequestContext>) {
        router.post(
            "/admin/newsletters/:newsletterId/issues/test-email/",
            use: send
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/:issueId/test-email/",
            use: send
        )
    }
}
