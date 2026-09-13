import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetRedirectOverviewDefaultController:
    AdminGetRedirectOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetRedirectOverviewInteractor,
            presenter: any AdminGetRedirectOverviewPresenter
        )

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getOverview()
        return try await presenter.renderOverview(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
