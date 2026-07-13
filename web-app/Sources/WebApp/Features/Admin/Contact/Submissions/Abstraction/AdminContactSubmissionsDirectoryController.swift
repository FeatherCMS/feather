import Hummingbird

protocol AdminContactSubmissionsDirectoryController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
}

extension AdminContactSubmissionsDirectoryController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/submissions/", use: list)
    }
}
