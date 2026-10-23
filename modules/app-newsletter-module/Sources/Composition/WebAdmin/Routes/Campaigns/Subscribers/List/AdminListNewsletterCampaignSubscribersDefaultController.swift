import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribersDefaultController:
    AdminListNewsletterCampaignSubscribersController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListNewsletterCampaignSubscribersInteractor,
            any AdminListNewsletterCampaignSubscribersPresenter
        >
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        let newsletterId = try context.requiredParameter("newsletterId")
        let search = request.querySearch()
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Subscriber.Permissions.list) else {
            return try await presenter.render(
                newsletterId: newsletterId,
                model: .init(
                    items: [],
                    pageState: .init(page: 1, pageSize: 20, total: 0)
                ),
                search: search,
                error: "Your account cannot access campaign subscribers.",
                permissions: permissions
            )
        }
        do {
            return try await presenter.render(
                newsletterId: newsletterId,
                model: try await interactor.list(
                    newsletterId: newsletterId,
                    search: search,
                    page: request.queryPage()
                ),
                search: search,
                error: nil,
                permissions: permissions
            )
        }
        catch {
            return try await presenter.render(
                newsletterId: newsletterId,
                model: .init(
                    items: [],
                    pageState: .init(
                        page: request.queryPage(),
                        pageSize: 20,
                        total: 0
                    )
                ),
                search: search,
                error: error.displayMessage,
                permissions: permissions
            )
        }
    }
}
