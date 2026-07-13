import Hummingbird

struct AdminManageNewsletterSubscribersDefaultController: AdminManageNewsletterSubscribersController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageNewsletterSubscribersInteractor, presenter: any AdminManageNewsletterSubscribersPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let search = request.querySearch()
        do { return presenter.renderList(newsletterId: newsletterId, items: try await interactor.list(newsletterId: newsletterId, search: search), search: search, error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderList(newsletterId: newsletterId, items: [], search: search, error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderForm(newsletterId: try context.requiredParameter("newsletterId"), email: "", firstName: "", lastName: "", status: "subscribed", isEdit: false, error: nil, permissions: context.currentUserPermissions)
    }

    func create(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let form = try await request.decode(as: NewsletterSubscriberForm.self, context: context)
        do { try await interactor.create(newsletterId: newsletterId, form: form); return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/\(newsletterId)/subscribers/", title: "Added", message: "Subscriber added successfully.")]) }
        catch { return try presenter.renderForm(newsletterId: newsletterId, email: form.email, firstName: form.firstName, lastName: form.lastName, status: form.status, isEdit: false, error: error.displayMessage, permissions: context.currentUserPermissions).response(from: request, context: context) }
    }

    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let email = try context.requiredParameter("email")
        do { let item = try await interactor.get(newsletterId: newsletterId, email: email); return presenter.renderForm(newsletterId: newsletterId, email: item.email, firstName: item.firstName, lastName: item.lastName, status: item.status, isEdit: true, error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderForm(newsletterId: newsletterId, email: email, firstName: "", lastName: "", status: "subscribed", isEdit: true, error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let email = try context.requiredParameter("email")
        let form = try await request.decode(as: NewsletterSubscriberForm.self, context: context)
        do { try await interactor.update(newsletterId: newsletterId, email: email, form: form); return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/\(newsletterId)/subscribers/", title: "Updated", message: "Subscriber updated successfully.")]) }
        catch { return try presenter.renderForm(newsletterId: newsletterId, email: email, firstName: form.firstName, lastName: form.lastName, status: form.status, isEdit: true, error: error.displayMessage, permissions: context.currentUserPermissions).response(from: request, context: context) }
    }

    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderRemoveConfirmation(newsletterId: try context.requiredParameter("newsletterId"), email: try context.requiredParameter("email"), permissions: context.currentUserPermissions)
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        try await interactor.remove(newsletterId: newsletterId, email: try context.requiredParameter("email"))
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/\(newsletterId)/subscribers/", title: "Removed", message: "Subscriber removed successfully.")])
    }

    func confirmBulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let emails = request.queryStrings("selectedIds")
        guard !emails.isEmpty else {
            return Response(status: .seeOther, headers: [.location: "/admin/newsletters/\(newsletterId)/subscribers/"])
        }
        return try presenter.renderBulkRemoveConfirmation(newsletterId: newsletterId, search: request.querySearch(), emails: emails, permissions: context.currentUserPermissions).response(from: request, context: context)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(newsletterId: newsletterId, emails: payload.normalizedSelectedIds)
        }
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/\(newsletterId)/subscribers/", title: "Removed", message: "Selected subscribers removed successfully.")])
    }
}
