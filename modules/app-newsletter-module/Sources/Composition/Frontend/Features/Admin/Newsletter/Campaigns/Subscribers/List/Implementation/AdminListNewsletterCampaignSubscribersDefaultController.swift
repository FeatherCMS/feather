import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribersDefaultController:
    AdminListNewsletterCampaignSubscribersController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminListNewsletterCampaignSubscribersInteractor,
            any AdminListNewsletterCampaignSubscribersPresenter
        >
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let newsletterId = try context.requiredParameter("newsletterId")
        let search = request.querySearch()
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Permissions.Subscribers.list) else {
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
