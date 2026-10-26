import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                Article.List.Runtime

        func getArticles(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let page = request.queryPage()
            let search = request.querySearch() ?? ""
            do {
                let model = try await runtime.interactor.search(
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
}
