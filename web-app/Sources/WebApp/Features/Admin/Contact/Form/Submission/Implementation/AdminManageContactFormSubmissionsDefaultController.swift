import Hummingbird

struct AdminManageContactFormSubmissionsDefaultController: AdminManageContactFormSubmissionsController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminManageContactFormSubmissionsInteractor, presenter: any AdminManageContactFormSubmissionsPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        do { return presenter.renderList(formId: formId, items: try await interactor.list(formId: formId), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderList(formId: formId, items: [], error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func get(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        do { return presenter.renderDetail(formId: formId, item: try await interactor.get(formId: formId, id: id), error: nil, permissions: context.currentUserPermissions) }
        catch { return presenter.renderDetail(formId: formId, item: .init(id: id, formId: formId, status: "received", submittedAt: "", values: [:]), error: error.displayMessage, permissions: context.currentUserPermissions) }
    }

    func update(request: Request, context: AppRequestContext) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("submissionId")
        let form = try await request.decode(as: ContactFormSubmissionStatusForm.self, context: context)
        try await interactor.update(formId: formId, id: id, status: form.status)
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/contact/forms/\(formId)/submissions/\(id)/", title: "Updated", message: "Submission updated successfully.")])
    }
}
