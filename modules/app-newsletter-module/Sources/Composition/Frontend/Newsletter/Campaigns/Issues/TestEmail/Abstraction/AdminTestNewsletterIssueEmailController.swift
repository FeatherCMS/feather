import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminTestNewsletterIssueEmailController: Sendable {
    func send(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminTestNewsletterIssueEmailController {
    func route(on router: Router<AppRequestContext>) {
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
