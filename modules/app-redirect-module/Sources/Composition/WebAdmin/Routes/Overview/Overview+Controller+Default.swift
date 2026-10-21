import FeatherWebAdmin
import Hummingbird

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
            let model = try await interactor.getOverview()
            return try await presenter.renderOverview(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
    }
}
