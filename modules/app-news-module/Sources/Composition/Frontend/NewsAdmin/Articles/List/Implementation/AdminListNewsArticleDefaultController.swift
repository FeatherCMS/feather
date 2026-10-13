import FeatherAdmin
import FeatherContracts
import Hummingbird
import NewsContracts

struct AdminListNewsArticleDefaultController: AdminListNewsArticleController {
    let buildRuntime: AdminNewsArticleRuntimeBuilder

    func getNewsArticles(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch() ?? ""
        do {
            let model = try await runtime.interactor.list(
                page: page,
                search: search.emptyToNil
            )
            return try await runtime.presenter.renderList(
                model: model,
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
