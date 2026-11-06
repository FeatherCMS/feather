import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Category.Detail.Interactor.Interface,
                    any Category.Detail.Presenter.Interface
                >

        func getNewsCategory(
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
