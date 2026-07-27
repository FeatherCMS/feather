import Hummingbird

struct AdminListContactFormItemsDefaultController:
    AdminListContactFormItemsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListContactFormItemsInteractor,
            presenter: any AdminListContactFormItemsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId =
            context.parameters.get("formId", as: String.self)
            ?? "__global_contact_fields__"
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list(formId: formId)
                .filter {
                    search.isEmpty
                        || $0.key.localizedCaseInsensitiveContains(search)
                        || $0.label.localizedCaseInsensitiveContains(search)
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
