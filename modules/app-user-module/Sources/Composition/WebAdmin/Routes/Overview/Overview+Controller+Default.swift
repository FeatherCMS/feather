import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Overview.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Overview.Interactor.Interface,
                any Overview.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            return try await presenter.renderPage(
                model: try await interactor.getOverview()
            )
        }
    }
}
