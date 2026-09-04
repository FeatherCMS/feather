import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterIssueController: Sendable {
    func getAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
    func postAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}
extension AdminAddNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: getAddNewsletterIssue
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: postAddNewsletterIssue
        )
    }
}
