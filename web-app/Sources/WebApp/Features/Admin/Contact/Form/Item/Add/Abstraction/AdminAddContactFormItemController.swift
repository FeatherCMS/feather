import Hummingbird
protocol AdminAddContactFormItemController: Sendable {
    func getAddContactFormItem(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func postAddContactFormItem(request: Request, context: AppRequestContext) async throws -> Response
}
extension AdminAddContactFormItemController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/items/add/", use: getAddContactFormItem)
        router.post("/admin/contact/forms/:formId/items/add/", use: postAddContactFormItem)
    }
}
