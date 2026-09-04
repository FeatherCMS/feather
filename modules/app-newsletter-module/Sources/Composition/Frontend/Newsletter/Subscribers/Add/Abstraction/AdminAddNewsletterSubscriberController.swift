import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterSubscriberController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func post(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminAddNewsletterSubscriberController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/subscribers/add/", use: get)
        router.post("/admin/newsletters/subscribers/add/", use: post)
    }
}
