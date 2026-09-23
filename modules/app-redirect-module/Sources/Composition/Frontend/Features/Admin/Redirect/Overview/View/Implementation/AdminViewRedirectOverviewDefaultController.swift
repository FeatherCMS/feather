import FeatherAdmin
import Hummingbird

struct AdminViewRedirectOverviewDefaultController:
    AdminViewRedirectOverviewController
{
    let buildRuntime: RuntimeBuilder<
        any AdminViewRedirectOverviewInteractor,
        any AdminViewRedirectOverviewPresenter
    >

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let model = try await interactor.getOverview()
        return try await presenter.renderOverview(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
