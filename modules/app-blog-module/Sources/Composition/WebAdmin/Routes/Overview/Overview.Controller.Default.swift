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
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let model = try await interactor.execute()
            return try await presenter.render(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
    }
}
