import Hummingbird

struct AdminListNewsletterCampaignsDefaultController:
    AdminListNewsletterCampaignsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListNewsletterCampaignsInteractor,
            presenter: any AdminListNewsletterCampaignsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list()
                .filter {
                    search.isEmpty
                        || $0.name.localizedCaseInsensitiveContains(search)
                }
            return presenter.render(
                items: items,
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                isPicker: request.hasQueryFlag("picker"),
                error: nil,
                permissions: context.currentUserPermissions,
                search: search
            )
        }
        catch {
            return presenter.render(
                items: [],
                isAdded: false,
                isEdited: false,
                isRemoved: false,
                isPicker: request.hasQueryFlag("picker"),
                error: error.displayMessage,
                permissions: context.currentUserPermissions,
                search: search
            )
        }
    }
}
