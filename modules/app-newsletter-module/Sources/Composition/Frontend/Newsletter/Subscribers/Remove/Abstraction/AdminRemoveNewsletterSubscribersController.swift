import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterSubscribersController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminRemoveNewsletterSubscribersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/remove/", use: confirm)
        router.post("/admin/newsletters/subscribers/remove/", use: remove)
    }
}
