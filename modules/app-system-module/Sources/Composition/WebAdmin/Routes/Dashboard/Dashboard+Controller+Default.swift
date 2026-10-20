import FeatherAdmin
import Foundation
import Hummingbird
import SystemModule

extension Dashboard.Controller {

    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Dashboard.Interactor.Interface,
                any Dashboard.Presenter.Interface
            >

        func getHome(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))

            let now = Date().timeIntervalSince1970
            let model = try await interactor.getHome(
                context: .init(
                    requestContext: context,
                    from: now - (7 * 24 * 60 * 60),
                    to: now
                )
            )
            return try await presenter.renderPage(model: model)
        }
    }
}
