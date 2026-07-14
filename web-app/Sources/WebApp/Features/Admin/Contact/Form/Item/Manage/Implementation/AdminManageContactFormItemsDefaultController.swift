import Hummingbird

struct AdminManageContactFormItemsDefaultController: AdminManageContactFormItemsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormItemsInteractor, presenter: any AdminManageContactFormItemsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list(formId: formId).filter { search.isEmpty || $0.key.localizedCaseInsensitiveContains(search) || $0.label.localizedCaseInsensitiveContains(search) }
            return presenter.renderList(formId: formId, items: items, search: search, error: nil, permissions: context.currentUserPermissions)
        }
        catch { return presenter.renderList(formId: formId, items: [], search: search, error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let id = try context.requiredParameter("itemId")
        do { return presenter.renderEdit(formId: formId, item: try await interactor.get(formId: formId, id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderEdit(formId: formId, item: .init(id: id, formId: formId, key: "", type: "text", label: "", allowedValues: "", isRequired: false, position: "0"), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let id = try context.requiredParameter("itemId")
        let form = try await request.decode(as: ContactFormItemAddForm.self, context: context)
        let basePath = formId == "__global_contact_fields__" ? "/admin/contact/fields/" : "/admin/contact/forms/\(formId)/items/"
        do { try await interactor.update(formId: formId, id: id, form: form); return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: basePath, title: "Updated", message: "Contact form field updated successfully.")]) }
        catch { return try presenter.renderEdit(formId: formId, item: .init(id: id, formId: formId, key: form.key, type: form.type, label: form.label, allowedValues: form.allowedValues, isRequired: form.isRequiredValue, position: form.position), error: error.displayMessage, permissions: context.currentUserPermissions).response(from: request, context: context) }
    }

    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let itemId = try context.requiredParameter("itemId")
        let item = try? await interactor.get(formId: formId, id: itemId)
        return presenter.renderRemoveConfirmation(formId: formId, itemId: itemId, label: item?.label ?? itemId, permissions: context.currentUserPermissions)
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        try await interactor.remove(formId: formId, id: try context.requiredParameter("itemId"))
        let basePath = formId == "__global_contact_fields__" ? "/admin/contact/fields/" : "/admin/contact/forms/\(formId)/items/"
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: basePath, title: "Removed", message: "Contact form field removed successfully.")])
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let selectedIds = request.queryStrings("selectedIds")
        let (_, presenter) = buildRuntime(request, context)
        guard !selectedIds.isEmpty else {
            let (interactor, _) = buildRuntime(request, context)
            let search = request.querySearch() ?? ""
            let items = (try? await interactor.list(formId: formId).filter { search.isEmpty || $0.key.localizedCaseInsensitiveContains(search) || $0.label.localizedCaseInsensitiveContains(search) }) ?? []
            return presenter.renderList(formId: formId, items: items, search: search, error: nil, permissions: context.currentUserPermissions)
        }
        return presenter.renderBulkRemoveConfirmation(formId: formId, selectedIds: selectedIds, permissions: context.currentUserPermissions)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let formId = context.parameters.get("formId", as: String.self) ?? "__global_contact_fields__"
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        let (interactor, _) = buildRuntime(request, context)
        if !payload.normalizedSelectedIds.isEmpty { try await interactor.bulkRemove(formId: formId, ids: payload.normalizedSelectedIds) }
        let basePath = formId == "__global_contact_fields__" ? "/admin/contact/fields/" : "/admin/contact/forms/\(formId)/items/"
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(path: basePath, page: 1, search: payload.normalizedSearch, title: payload.normalizedSelectedIds.isEmpty ? nil : "Removed", message: payload.normalizedSelectedIds.isEmpty ? nil : "Contact form fields removed successfully.")])
    }
}
