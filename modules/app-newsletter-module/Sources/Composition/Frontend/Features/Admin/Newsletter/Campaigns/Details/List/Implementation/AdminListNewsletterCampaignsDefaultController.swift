import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminListNewsletterCampaignsDefaultController:
    AdminListNewsletterCampaignsController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListNewsletterCampaignsInteractor,
            any AdminListNewsletterCampaignsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Permissions.Campaigns.list) else {
            return try await presenter.render(
                model: .init(
                    items: [],
                    pageState: .init(page: 1, pageSize: 20, total: 0)
                ),
                isPicker: request.hasQueryFlag("picker"),
                error: "Your account cannot access newsletter campaigns.",
                permissions: permissions,
                search: request.querySearch()
            )
        }
        do {
            return try await presenter.render(
                model: try await interactor.list(
                    page: request.queryPage(),
                    search: request.querySearch()
                ),
                isPicker: request.hasQueryFlag("picker"),
                error: nil,
                permissions: permissions,
                search: request.querySearch()
            )
        }
        catch {
            return try await presenter.render(
                model: .init(
                    items: [],
                    pageState: .init(
                        page: request.queryPage(),
                        pageSize: 20,
                        total: 0
                    )
                ),
                isPicker: request.hasQueryFlag("picker"),
                error: error.displayMessage,
                permissions: permissions,
                search: request.querySearch()
            )
        }
    }
}
