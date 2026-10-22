import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Overview.View.Controller {
    struct Default: Overview.View.Controller.Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Overview.View.Interactor.Interface,
                any Overview.View.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            return try await presenter.renderOverview(
                model: try await interactor.getOverview()
            )
        }
    }
}
