import Hummingbird

protocol AdminListContactFormEmailsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormEmailsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/emails/", use: list)
    }
}
