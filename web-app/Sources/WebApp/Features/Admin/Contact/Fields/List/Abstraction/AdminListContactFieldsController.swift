import Hummingbird

protocol AdminListContactFieldsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFieldsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/fields/", use: list)
    }
}
