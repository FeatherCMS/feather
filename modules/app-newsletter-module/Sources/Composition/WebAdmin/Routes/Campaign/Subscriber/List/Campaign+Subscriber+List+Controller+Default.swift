import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.List.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.List.Interactor.Interface,
                any Campaign.Subscriber.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let search = request.querySearch()
            let page = request.queryPage()
            let permissions = context.currentUserAdminListActions

            guard permissions.allows(Subscriber.Permissions.list) else {
                return try await runtime.presenter.render(
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
                let model = try await runtime.interactor.list(
                    newsletterId: newsletterId,
                    search: search,
                    page: page
                )
                return try await runtime.presenter.render(
                    newsletterId: newsletterId,
                    model: model,
                    search: search,
                    error: nil,
                    permissions: permissions
                )
            }
            catch {
                return try await runtime.presenter.render(
                    newsletterId: newsletterId,
                    model: .init(
                        items: [],
                        pageState: .init(page: page, pageSize: 20, total: 0)
                    ),
                    search: search,
                    error: error.displayMessage,
                    permissions: permissions
                )
            }
        }
    }
}
