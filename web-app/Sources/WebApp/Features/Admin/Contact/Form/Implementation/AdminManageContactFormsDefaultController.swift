import Hummingbird

struct AdminManageContactFormsDefaultController: AdminManageContactFormsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormsInteractor, presenter: any AdminManageContactFormsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        do { return presenter.renderList(items: try await interactor.list(), isAdded: request.hasQueryFlag("added"), isEdited: request.hasQueryFlag("edited"), isRemoved: request.hasQueryFlag("removed"), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderList(items: [], isAdded: false, isEdited: false, isRemoved: false, error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderEdit(item: .init(id: "", name: ""), error: nil, permissions: context.currentUserPermissions)
    }

    func create(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let form = try await request.decode(as: ContactFormEditForm.self, context: context)
        try await interactor.create(name: form.name)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/", title: "Added", message: "Contact form added successfully.")])
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
        let form = try await request.decode(as: ContactFormEditForm.self, context: context)
        _ = try await interactor.update(id: id, name: form.name)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/", title: "Updated", message: "Contact form updated successfully.")])
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(id: try context.requiredID())
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/", title: "Removed", message: "Contact form removed successfully.")])
    }
}
