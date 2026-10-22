import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

struct AdminListNewsCategoryDefaultController:
    AdminListNewsCategoryController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) ->
            AdminNewsCategoryRuntime

    func getNewsCategories(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch() ?? ""
        guard context.isCurrentUserAllowed(to: Category.Permissions.list)
        else {
            return try await runtime.presenter.renderList(
                model: .init(items: [], total: 0, page: page, pageSize: 20),
                search: search,
                error: nil
            )
        }
        do {
            return try await runtime.presenter.renderList(
                model: try await runtime.interactor.list(
                    page: page,
                    search: search.emptyToNil
                ),
                search: search,
                error: nil
            )
        }
        catch {
            return try await runtime.presenter.renderList(
                model: .init(items: [], total: 0, page: page, pageSize: 20),
                search: search,
                error: error.displayMessage
            )
        }
    }
}
