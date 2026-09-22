import FeatherAdmin
import FeatherContracts
import Hummingbird
import NewsletterContracts

struct AdminListNewsletterSubscribersDefaultController:
    AdminListNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListNewsletterSubscribersInteractor,
            presenter: any AdminListNewsletterSubscribersPresenter
        )

    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let campaignId = request.queryString("campaignId")?
            .whitespaceTrimmed
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Permissions.Subscribers.list) else {
            return try await presenter.render(
                model: .init(
                    items: [],
                    campaigns: [],
                    search: request.querySearch() ?? "",
                    campaignId: campaignId ?? "",
                    pageState: .init(page: 1, pageSize: 20, total: 0)
                ),
                error: "Your account cannot access newsletter subscribers.",
                permissions: context.currentUserPermissions
            )
        }
        do {
            return try await presenter.render(
                model: try await interactor.list(
                    search: request.querySearch(),
                    campaignId: campaignId,
                    page: request.queryPage()
                ),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.render(
                model: .init(
                    items: [],
                    campaigns: [],
                    search: request.querySearch() ?? "",
                    campaignId: campaignId ?? "",
                    pageState: .init(
                        page: request.queryPage(),
                        pageSize: 20,
                        total: 0
                    )
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
