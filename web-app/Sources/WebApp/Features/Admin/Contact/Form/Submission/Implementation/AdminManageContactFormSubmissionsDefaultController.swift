import Hummingbird

struct AdminManageContactFormSubmissionsDefaultController: AdminManageContactFormSubmissionsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormSubmissionsInteractor, presenter: any AdminManageContactFormSubmissionsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list(formId: formId).filter { search.isEmpty || $0.status.localizedCaseInsensitiveContains(search) || $0.createdAt.localizedCaseInsensitiveContains(search) }
            return presenter.renderList(formId: formId, items: items, search: search, error: nil, permissions: context.currentUserPermissions)
        }
        catch { return presenter.renderList(formId: formId, items: [], search: search, error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func get(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        do { return presenter.renderDetail(formId: formId, item: try await interactor.get(formId: formId, id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderDetail(formId: formId, item: .init(id: id, formId: formId, status: "received", createdAt: "", values: [:]), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        let form = try await request.decode(as: ContactFormSubmissionStatusForm.self, context: context)
        try await interactor.update(formId: formId, id: id, status: form.status)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/submissions/\(id)/", title: "Updated", message: "Submission updated successfully.")])
    }

    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        return presenter.renderRemoveConfirmation(formId: formId, item: try await interactor.get(formId: formId, id: id), permissions: context.currentUserPermissions)
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        try await interactor.remove(formId: formId, id: id)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/submissions/", title: "Removed", message: "Contact form submission removed successfully.")])
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let selectedIds = request.queryStrings("selectedIds")
        guard !selectedIds.isEmpty else { return presenter.renderList(formId: formId, items: [], search: request.querySearch() ?? "", error: nil, permissions: context.currentUserPermissions) }
        return presenter.renderBulkRemoveConfirmation(formId: formId, selectedIds: selectedIds, permissions: context.currentUserPermissions)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        if !payload.normalizedSelectedIds.isEmpty { try await interactor.bulkRemove(formId: formId, ids: payload.normalizedSelectedIds) }
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(path: "/admin/contact/forms/\(formId)/submissions/", page: 1, search: payload.normalizedSearch, title: payload.normalizedSelectedIds.isEmpty ? nil : "Removed", message: payload.normalizedSelectedIds.isEmpty ? nil : "Contact form submissions removed successfully.")])
    }
}
