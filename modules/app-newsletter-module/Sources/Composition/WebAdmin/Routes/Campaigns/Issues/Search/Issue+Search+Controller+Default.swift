import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Search.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Issue.Search.Interactor.Interface,
                any Issue.Search.Presenter.Interface
            >

        func search(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let newsletterId = try context.requiredParameter("newsletterId")
            let permissions = context.currentUserAdminListActions
            guard permissions.allows(Issue.Permissions.list) else {
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
                    model: try await interactor.search(
                        newsletterId: newsletterId,
                        page: request.queryPage(),
                        search: request.querySearch()
                    ),
                    error: nil,
                    permissions: permissions,
                    search: request.querySearch()
                )
            } catch {
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
}
