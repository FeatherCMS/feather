import Hummingbird

struct AdminManageContactFormItemsDefaultController: AdminManageContactFormItemsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormItemsInteractor, presenter: any AdminManageContactFormItemsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        do { return presenter.renderList(formId: formId, items: try await interactor.list(formId: formId), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderList(formId: formId, items: [], error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("itemId")
        do { return presenter.renderEdit(formId: formId, item: try await interactor.get(formId: formId, id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderEdit(formId: formId, item: .init(id: id, formId: formId, key: "", type: "text", label: "", allowedValues: "", isRequired: false, position: "0"), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("itemId")
        let form = try await request.decode(as: ContactFormItemAddForm.self, context: context)
        do { try await interactor.update(formId: formId, id: id, form: form); return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/items/", title: "Updated", message: "Contact form field updated successfully.")]) }
        catch { return try presenter.renderEdit(formId: formId, item: .init(id: id, formId: formId, key: form.key, type: form.type, label: form.label, allowedValues: form.allowedValues, isRequired: form.isRequiredValue, position: form.position), error: error.displayMessage, permissions: context.currentUserPermissions).response(from: request, context: context) }
    }

    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let itemId = try context.requiredParameter("itemId")
        let item = try? await interactor.get(formId: formId, id: itemId)
        return presenter.renderRemoveConfirmation(formId: formId, itemId: itemId, label: item?.label ?? itemId, permissions: context.currentUserPermissions)
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        try await interactor.remove(formId: formId, id: try context.requiredParameter("itemId"))
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/items/", title: "Removed", message: "Contact form field removed successfully.")])
    }
}
