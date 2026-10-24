import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Article.Detail.Interactor.Interface,
                    any Article.Detail.Presenter.Interface
                >

        func getNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            do {
                let item = try await runtime.interactor.get(
                    id: context.requiredID()
                )
                return try await runtime.presenter.renderDetails(item: item)
            }
            catch {
                return try await runtime.presenter.renderError(
                    error.displayMessage
                )
            }
        }
    }
}
