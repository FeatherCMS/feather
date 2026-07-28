import Hummingbird

protocol AdminListContactFormsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/", use: list)
    }
}
