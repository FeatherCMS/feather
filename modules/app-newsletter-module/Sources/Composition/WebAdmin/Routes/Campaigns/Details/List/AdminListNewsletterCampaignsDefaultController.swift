import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

struct AdminListNewsletterCampaignsDefaultController:
    AdminListNewsletterCampaignsController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListNewsletterCampaignsInteractor,
            any AdminListNewsletterCampaignsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Campaign.Permissions.list) else {
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
