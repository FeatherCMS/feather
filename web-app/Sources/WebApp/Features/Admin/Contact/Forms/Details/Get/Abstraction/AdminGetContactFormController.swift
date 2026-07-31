import Hummingbird

protocol AdminGetContactFormController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetContactFormController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/details/", use: get)
    }
}
