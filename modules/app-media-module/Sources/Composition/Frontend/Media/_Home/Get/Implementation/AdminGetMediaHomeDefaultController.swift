import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetMediaHomeDefaultController: AdminGetMediaHomeController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetMediaHomeInteractor,
            presenter: any AdminGetMediaHomePresenter
        )

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getHome(),
            permissions: context.currentUserPermissions
        )
    }
}
