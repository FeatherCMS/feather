import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterSubscribersController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterSubscribersController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/subscribers/", use: list)
    }
}
