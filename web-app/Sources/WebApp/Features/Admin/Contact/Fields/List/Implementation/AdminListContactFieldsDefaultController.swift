import Hummingbird

struct AdminListContactFieldsDefaultController:
    AdminListContactFieldsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListContactFieldsInteractor,
            presenter: any AdminListContactFieldsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let fields = try await interactor.list().filter {
                search.isEmpty
                    || $0.key.localizedCaseInsensitiveContains(search)
                    || $0.label.localizedCaseInsensitiveContains(search)
            }
            return presenter.renderList(
                fields: fields,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderList(
                fields: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
