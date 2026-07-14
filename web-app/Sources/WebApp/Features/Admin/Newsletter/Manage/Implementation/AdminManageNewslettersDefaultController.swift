import Hummingbird

struct AdminManageNewslettersDefaultController: AdminManageNewslettersController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageNewslettersInteractor, presenter: any AdminManageNewslettersPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list().filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
            return presenter.renderList(items: items, isAdded: request.hasQueryFlag("added"), isEdited: request.hasQueryFlag("edited"), isRemoved: request.hasQueryFlag("removed"), error: nil, permissions: context.currentUserPermissions, search: search)
        }
        catch { return presenter.renderList(items: [], isAdded: false, isEdited: false, isRemoved: false, error: error.displayMessage, permissions: context.currentUserPermissions, search: search) }
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch() ?? ""
        guard !selectedIds.isEmpty else {
            return presenter.renderList(items: [], isAdded: false, isEdited: false, isRemoved: false, error: nil, permissions: context.currentUserPermissions, search: search)
        }
        return presenter.renderBulkRemoveConfirmation(page: page, search: search, selectedIds: selectedIds, permissions: context.currentUserPermissions)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        if !payload.normalizedSelectedIds.isEmpty { try await interactor.bulkRemove(ids: payload.normalizedSelectedIds) }
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(path: "/admin/newsletters/", page: 1, search: payload.normalizedSearch, title: payload.normalizedSelectedIds.isEmpty ? nil : "Removed", message: payload.normalizedSelectedIds.isEmpty ? nil : "Campaigns removed successfully.")])
    }


    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do { return presenter.renderEdit(item: try await interactor.get(id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderEdit(item: .init(id: id, name: ""), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let id = try context.requiredID()
        let form = try await request.decode(as: NewsletterEditForm.self, context: context)
        _ = try await interactor.update(id: id, name: form.name)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/", title: "Updated", message: "Campaign updated successfully.")])
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(id: try context.requiredID())
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/", title: "Removed", message: "Campaign removed successfully.")])
    }
}
