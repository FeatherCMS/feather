import Hummingbird

struct AdminListNewsletterSubscribersDefaultController:
    AdminListNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListNewsletterSubscribersInteractor,
            presenter: any AdminListNewsletterSubscribersPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let campaignId = request.queryString("campaignId")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            return presenter.render(
                model: try await interactor.list(
                    search: request.querySearch(),
                    campaignId: campaignId
                ),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                model: .init(
                    items: [],
                    campaigns: [],
                    search: request.querySearch() ?? "",
                    campaignId: campaignId ?? ""
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
