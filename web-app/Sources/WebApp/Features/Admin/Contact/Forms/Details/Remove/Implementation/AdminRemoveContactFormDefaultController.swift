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
        let formId = try context.requiredParameter("formId")
        do {
            let item = try await interactor.get(id: formId)
            return presenter.renderConfirmation(
                id: formId,
                name: item.name,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderConfirmation(
                id: formId,
                name: formId,
                permissions: context.currentUserPermissions
            )
        }
    }

    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/contact/forms/",
                    page: 1,
                    search: payload.normalizedSearch,
                    title: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Removed",
                    message: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Contact forms removed successfully."
                )
            ]
        )
    }
}
