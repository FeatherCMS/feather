import FeatherAdmin
import FeatherContracts
import Hummingbird
import NewsContracts

struct AdminListNewsCategoryDefaultController:
    AdminListNewsCategoryController
{
    let buildRuntime: AdminNewsCategoryRuntimeBuilder

    func getNewsCategories(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch() ?? ""
        guard context.isCurrentUserAllowed(to: NewsPermissions.Categories.list)
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
