import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterSubscribersController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminRemoveNewsletterSubscribersController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/subscribers/remove/", use: confirm)
        router.post("/admin/newsletters/subscribers/remove/", use: remove)
    }
}
