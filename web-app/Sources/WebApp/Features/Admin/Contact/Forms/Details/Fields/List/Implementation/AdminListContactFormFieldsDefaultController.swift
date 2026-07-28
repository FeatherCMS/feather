import Hummingbird

struct AdminListContactFormFieldsDefaultController:
    AdminListContactFormFieldsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListContactFormFieldsInteractor,
            presenter: any AdminListContactFormFieldsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        let search = request.querySearch() ?? ""
        do {
            let fields = try await interactor.list(formId: formId)
                .filter {
                    search.isEmpty
                        || $0.key.localizedCaseInsensitiveContains(search)
                        || $0.label.localizedCaseInsensitiveContains(search)
                }
            return presenter.renderList(
                formId: formId,
                fields: fields,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderList(
                formId: formId,
                fields: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
