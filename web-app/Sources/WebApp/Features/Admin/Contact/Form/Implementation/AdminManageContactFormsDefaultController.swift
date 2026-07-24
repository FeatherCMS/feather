import Hummingbird

struct AdminManageContactFormsDefaultController: AdminManageContactFormsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormsInteractor, presenter: any AdminManageContactFormsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list().filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
            return presenter.renderList(items: items, search: search, isAdded: request.hasQueryFlag("added"), isEdited: request.hasQueryFlag("edited"), isRemoved: request.hasQueryFlag("removed"), isPicker: request.hasQueryFlag("picker"), error: nil, permissions: context.currentUserPermissions)
        }
        catch { return presenter.renderList(items: [], search: search, isAdded: false, isEdited: false, isRemoved: false, isPicker: request.hasQueryFlag("picker"), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        do {
            let fields = try await interactor.availableFields()
            return presenter.renderEdit(item: .init(id: "", name: "", successMessage: "", failureMessage: "", redirectUrl: nil, selectedFieldIDs: [], availableFields: fields, mails: []), error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.renderEdit(item: .init(id: "", name: "", successMessage: "", failureMessage: "", redirectUrl: nil, selectedFieldIDs: [], availableFields: [], mails: []), error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }

    func create(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let form = try await request.decode(as: ContactFormEditForm.self, context: context)
        _ = try await interactor.create(name: form.name, successMessage: form.successMessage ?? "", failureMessage: form.failureMessage ?? "", redirectUrl: form.redirectUrl, fieldIDs: form.fieldIds ?? [], mails: form.mails)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/", title: "Added", message: "Contact form added successfully.")])
    }

    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do { return presenter.renderEdit(item: try await interactor.get(id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderEdit(item: .init(id: id, name: "", successMessage: "", failureMessage: "", redirectUrl: nil, selectedFieldIDs: [], availableFields: [], mails: []), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func emails(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do { return presenter.renderEmails(item: try await interactor.get(id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderEmails(item: .init(id: id, name: "", successMessage: "", failureMessage: "", redirectUrl: nil, selectedFieldIDs: [], availableFields: [], mails: []), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func updateEmails(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let id = try context.requiredID()
        let current = try await interactor.get(id: id)
        let form = try await request.decode(as: ContactFormEditForm.self, context: context)
        _ = try await interactor.update(id: id, name: current.name, successMessage: current.successMessage, failureMessage: current.failureMessage, redirectUrl: current.redirectUrl, fieldIDs: current.selectedFieldIDs, mails: form.mails)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(id)/emails/", title: "Updated", message: "Contact form emails updated successfully.")])
    }

    func confirmRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let item = try await interactor.get(id: id)
            return presenter.renderRemoveConfirmation(
                id: id,
                name: item.name,
                permissions: context.currentUserPermissions
            )
        } catch {
            return presenter.renderRemoveConfirmation(
                id: id,
                name: id,
                permissions: context.currentUserPermissions
            )
        }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let id = try context.requiredID()
        let form = try await request.decode(as: ContactFormEditForm.self, context: context)
        let current = try await interactor.get(id: id)
        _ = try await interactor.update(id: id, name: form.name, successMessage: form.successMessage ?? "", failureMessage: form.failureMessage ?? "", redirectUrl: form.redirectUrl, fieldIDs: form.fieldIds ?? [], mails: form.mails.isEmpty ? current.mails : form.mails)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(id)/edit/", title: "Saved", message: "Contact form updated successfully.")])
    }

    func remove(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(id: try context.requiredID())
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/", title: "Removed", message: "Contact form removed successfully.")])
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let selectedIds = request.queryStrings("selectedIds")
        guard !selectedIds.isEmpty else {
            let (interactor, presenter) = buildRuntime(request, context)
            let items = (try? await interactor.list()) ?? []
            return presenter.renderList(items: items, search: request.querySearch() ?? "", isAdded: false, isEdited: false, isRemoved: false, isPicker: request.hasQueryFlag("picker"), error: nil, permissions: context.currentUserPermissions)
        }
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderBulkRemoveConfirmation(selectedIds: selectedIds, permissions: context.currentUserPermissions)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        let (interactor, _) = buildRuntime(request, context)
        if !payload.normalizedSelectedIds.isEmpty { try await interactor.bulkRemove(ids: payload.normalizedSelectedIds) }
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(path: "/admin/contact/forms/", page: 1, search: payload.normalizedSearch, title: payload.normalizedSelectedIds.isEmpty ? nil : "Removed", message: payload.normalizedSelectedIds.isEmpty ? nil : "Contact forms removed successfully.")])
    }

    func addEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredID()
        do {
            let form = try await interactor.get(id: formId)
            let selectedFields = form.availableFields.filter { form.selectedFieldIDs.contains($0.id) }
            return presenter.renderEmailAdd(formId: formId, availableFields: selectedFields, error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.renderEmailAdd(formId: formId, availableFields: [], error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }

    func createEmail(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredID()
        let current = try await interactor.get(id: formId)
        let input = try await request.decode(as: ContactFormMailFormInput.self, context: context)
        _ = try await interactor.update(id: formId, name: current.name, successMessage: current.successMessage, failureMessage: current.failureMessage, redirectUrl: current.redirectUrl, fieldIDs: current.selectedFieldIDs, mails: current.mails + [input.mail])
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/emails/", title: "Added", message: "Contact form email added successfully.")])
    }

    func editEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredID()
        let mailId = try context.requiredParameter("mailId")
        do {
            guard let mail = try await interactor.get(id: formId).mails.first(where: { $0.id == mailId }) else { throw HTTPError(.notFound) }
            let form = try await interactor.get(id: formId)
            let selectedFields = form.availableFields.filter { form.selectedFieldIDs.contains($0.id) }
            return presenter.renderEmailEdit(formId: formId, mail: mail, availableFields: selectedFields, error: nil, permissions: context.currentUserPermissions)
        } catch { return presenter.renderEmailAdd(formId: formId, availableFields: [], error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func updateEmail(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredID()
        let mailId = try context.requiredParameter("mailId")
        let current = try await interactor.get(id: formId)
        let input = try await request.decode(as: ContactFormMailFormInput.self, context: context)
        guard current.mails.contains(where: { $0.id == mailId }) else { throw OpenAPIRepositoryError.notFound(message: "This contact form email could not be found.") }
        let mails = current.mails.map { $0.id == mailId ? input.mail : $0 }
        _ = try await interactor.update(id: formId, name: current.name, successMessage: current.successMessage, failureMessage: current.failureMessage, redirectUrl: current.redirectUrl, fieldIDs: current.selectedFieldIDs, mails: mails)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/emails/", title: "Updated", message: "Contact form email updated successfully.")])
    }

    func confirmRemoveEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredID()
        let mailId = try context.requiredParameter("mailId")
        do {
            guard let mail = try await interactor.get(id: formId).mails.first(where: { $0.id == mailId }) else { throw HTTPError(.notFound) }
            return presenter.renderEmailRemove(formId: formId, mail: mail, permissions: context.currentUserPermissions)
        } catch { return presenter.renderEmailAdd(formId: formId, availableFields: [], error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func removeEmail(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredID()
        let mailId = try context.requiredParameter("mailId")
        let current = try await interactor.get(id: formId)
        guard current.mails.contains(where: { $0.id == mailId }) else { throw OpenAPIRepositoryError.notFound(message: "This contact form email could not be found.") }
        _ = try await interactor.update(id: formId, name: current.name, successMessage: current.successMessage, failureMessage: current.failureMessage, redirectUrl: current.redirectUrl, fieldIDs: current.selectedFieldIDs, mails: current.mails.filter { $0.id != mailId })
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/emails/", title: "Removed", message: "Contact form email removed successfully.")])
    }
}
