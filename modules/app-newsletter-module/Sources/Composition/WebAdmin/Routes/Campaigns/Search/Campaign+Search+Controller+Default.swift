import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Search.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Search.Interactor.Interface,
                any Campaign.Search.Presenter.Interface
            >

        func getSearchPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserAdminListActions
            let page = request.queryPage()
            let search = request.querySearch()
            let isPicker = request.hasQueryFlag("picker")

            guard permissions.allows(Campaign.Permissions.list) else {
                return try await runtime.presenter.render(
                    model: .init(
                        items: [],
                        pageState: .init(page: page, pageSize: 20, total: 0)
                    ),
                    isPicker: isPicker,
                    error: "Your account cannot access newsletter campaigns.",
                    permissions: permissions,
                    search: search
                )
            }
            do {
                return try await runtime.presenter.render(
                    model: try await runtime.interactor.searchCampaigns(
                        page: page,
                        search: search
                    ),
                    isPicker: isPicker,
                    error: nil,
                    permissions: permissions,
                    search: search
                )
            }
            catch {
                return try await runtime.presenter.render(
                    model: .init(
                        items: [],
                        pageState: .init(
                            page: page,
                            pageSize: 20,
                            total: 0
                        )
                    ),
                    isPicker: isPicker,
                    error: error.displayMessage,
                    permissions: permissions,
                    search: search
                )
            }
        }
    }
}
