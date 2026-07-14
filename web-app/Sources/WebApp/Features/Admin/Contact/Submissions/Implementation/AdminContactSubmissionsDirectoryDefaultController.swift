import Hummingbird

struct AdminContactSubmissionsDirectoryDefaultController: AdminContactSubmissionsDirectoryController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminContactSubmissionsDirectoryInteractor, presenter: AdminContactSubmissionsDirectoryDefaultPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list().filter { search.isEmpty || $0.formName.localizedCaseInsensitiveContains(search) || $0.status.localizedCaseInsensitiveContains(search) || $0.createdAt.localizedCaseInsensitiveContains(search) }
            return presenter.render(items: items, search: search, error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.render(items: [], search: search, error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        guard !selectedIds.isEmpty else { return presenter.render(items: [], search: request.querySearch() ?? "", error: nil, permissions: context.currentUserPermissions) }
        return presenter.renderBulkRemoveConfirmation(selectedIds: selectedIds, permissions: context.currentUserPermissions)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        if !payload.normalizedSelectedIds.isEmpty { try await interactor.bulkRemove(ids: payload.normalizedSelectedIds) }
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(path: "/admin/contact/submissions/", page: 1, search: payload.normalizedSearch, title: payload.normalizedSelectedIds.isEmpty ? nil : "Removed", message: payload.normalizedSelectedIds.isEmpty ? nil : "Contact submissions removed successfully.")])
    }
}
