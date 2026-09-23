import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaOverviewDefaultController: AdminViewMediaOverviewController
{
    let buildRuntime: RuntimeBuilder<
        any AdminViewMediaOverviewInteractor,
        any AdminViewMediaOverviewPresenter
    >

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        return try await presenter.renderOverview(
            model: try await interactor.getOverview()
        )
    }
}
