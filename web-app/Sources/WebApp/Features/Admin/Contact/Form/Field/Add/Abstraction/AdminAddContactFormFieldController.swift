import Hummingbird

protocol AdminAddContactFormFieldController: Sendable {
    func getAddContactFormField(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func postAddContactFormField(request: Request, context: AppRequestContext)
        async throws -> Response
}
extension AdminAddContactFormFieldController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/items/add/",
            use: getAddContactFormField
        )
        router.post(
            "/admin/contact/forms/:formId/items/add/",
            use: postAddContactFormField
        )
        router.get("/admin/contact/fields/add/", use: getAddContactFormField)
        router.post("/admin/contact/fields/add/", use: postAddContactFormField)
    }
}
