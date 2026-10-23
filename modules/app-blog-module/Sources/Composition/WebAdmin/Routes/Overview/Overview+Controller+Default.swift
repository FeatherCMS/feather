import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

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
            let model = try await interactor.execute()
            return try await presenter.render(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
    }
}
