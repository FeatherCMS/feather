import Hummingbird

protocol AdminEditContactFormFieldController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFormFieldController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/items/:fieldId/edit/",
            use: edit
        )
        router.post(
            "/admin/contact/forms/:formId/items/:fieldId/edit/",
            use: update
        )
        router.get("/admin/contact/fields/:fieldId/edit/", use: edit)
        router.post("/admin/contact/fields/:fieldId/edit/", use: update)
    }
}
