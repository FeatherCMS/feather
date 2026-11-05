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
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            return try await presenter.renderPage(
                model: try await interactor.getOverview()
            )
        }
    }
}
