import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterSubscribersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterSubscribersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/", use: list)
    }
}
