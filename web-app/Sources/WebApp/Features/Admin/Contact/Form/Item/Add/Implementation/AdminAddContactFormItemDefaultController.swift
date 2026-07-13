import Hummingbird

struct AdminAddContactFormItemDefaultController: AdminAddContactFormItemController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminAddContactFormItemInteractor, presenter: any AdminAddContactFormItemPresenter)
    func getAddContactFormItem(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        return presenter.renderPage(model: try await interactor.getAddContactFormItem(formId: formId), permissions: context.currentUserPermissions)
    }
    func postAddContactFormItem(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(as: ContactFormItemAddForm.self, context: context)
        let model = try await interactor.postAddContactFormItem(formId: formId, payload: payload)
        if model.error == nil { return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/items/", title: "Added", message: "Form item added successfully.")]) }
        return try presenter.renderPage(model: model, permissions: context.currentUserPermissions).response(from: request, context: context)
    }
}
