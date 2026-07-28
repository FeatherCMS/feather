import Hummingbird

struct AdminRemoveContactFormDefaultController: AdminRemoveContactFormController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveContactFormInteractor,
            presenter: any AdminRemoveContactFormPresenter
        )

    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        if selectedIds.count == 1, let formId = selectedIds.first {
            let item = try await interactor.get(id: formId)
            return presenter.renderConfirmation(
                id: formId,
                name: item.name,
                permissions: context.currentUserPermissions
            )
        }
        else {
            return presenter.renderBulkConfirmation(
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
        }
    }

    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let payload = try await request.decode(as: ListBulkRemoveFormInput.self, context: context)
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        return Response(status: .seeOther, headers: [.location: ListBulkRemoveRedirect.location(
            path: "/admin/contact/forms/", page: payload.normalizedPage,
            search: payload.normalizedSearch, title: "Removed",
            message: "Contact forms removed successfully."
        )])
    }
}
