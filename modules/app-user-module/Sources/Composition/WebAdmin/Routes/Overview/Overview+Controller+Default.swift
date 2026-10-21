import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Overview.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Overview.Interactor.Interface,
                any Overview.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            return try await presenter.renderPage(
                model: try await interactor.getOverview()
            )
        }
    }
}
