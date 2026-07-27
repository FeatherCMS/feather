import Hummingbird

protocol AdminAddContactNewsletterController: Sendable {
    func getAddContactNewsletter(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func postAddContactNewsletter(request: Request, context: AppRequestContext)
        async throws -> Response
}

extension AdminAddContactNewsletterController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/add/", use: getAddContactNewsletter)
        router.post("/admin/newsletters/add/", use: postAddContactNewsletter)
    }
}
