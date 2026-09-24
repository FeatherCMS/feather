import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminListNewsletterIssuesDefaultController:
    AdminListNewsletterIssuesController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListNewsletterIssuesInteractor,
            any AdminListNewsletterIssuesPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let newsletterId = try request.requiredParameter("newsletterId")
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(Permissions.Issues.list) else {
            return try await presenter.render(
                newsletterId: newsletterId,
                model: .init(
                    items: [],
                    pageState: .init(page: 1, pageSize: 20, total: 0)
                ),
                error: "Your account cannot access campaign issues.",
                permissions: permissions,
                search: request.querySearch()
            )
        }
        do {
            return try await presenter.render(
                newsletterId: newsletterId,
                model: try await interactor.list(
                    newsletterId: newsletterId,
                    page: request.queryPage(),
                    search: request.querySearch()
                ),
                error: nil,
                permissions: permissions,
                search: request.querySearch()
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
                error: error.displayMessage,
                permissions: permissions,
                search: request.querySearch()
            )
        }
    }
}
