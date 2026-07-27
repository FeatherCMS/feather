import Hummingbird

struct AdminListContactFormSubmissionsDefaultController:
    AdminListContactFormSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListContactFormSubmissionsInteractor,
            presenter: any AdminListContactFormSubmissionsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list(formId: formId)
                .filter {
                    search.isEmpty
                        || $0.status.localizedCaseInsensitiveContains(search)
                        || $0.createdAt.localizedCaseInsensitiveContains(search)
                }
            return presenter.renderList(
                formId: formId,
                items: items,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderList(
                formId: formId,
                items: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
