import Hummingbird

protocol AdminAddContactFieldController: Sendable {
    func getAddContactField(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func postAddContactField(request: Request, context: AppRequestContext)
        async throws -> Response
}
extension AdminAddContactFieldController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/fields/add/", use: getAddContactField)
        router.post("/admin/contact/fields/add/", use: postAddContactField)
    }
}
