import Hummingbird

struct AdminRemoveContactFormSubmissionsDefaultController:
    AdminRemoveContactFormSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveContactFormSubmissionsInteractor,
            presenter: any AdminRemoveContactFormSubmissionsPresenter
        )

    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        return presenter.renderConfirmation(
            formId: formId,
            item: try await interactor.get(formId: formId, id: submissionId),
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        try await interactor.remove(formId: formId, id: submissionId)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/submissions/",
                    title: "Removed",
                    message: "Contact form submission removed successfully."
                )
            ]
        )
    }

    func bulkConfirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let selectedIds = request.queryStrings("selectedIds")
        guard !selectedIds.isEmpty else {
            return presenter.renderBulkConfirmation(
                formId: formId,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
        }
        return presenter.renderBulkConfirmation(
            formId: formId,
            selectedIds: selectedIds,
            permissions: context.currentUserPermissions
        )
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(
                formId: formId,
                ids: payload.normalizedSelectedIds
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/submissions/",
                    page: 1,
                    search: payload.normalizedSearch,
                    title: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Removed",
                    message: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Contact form submissions removed successfully."
                )
            ]
        )
    }
}
