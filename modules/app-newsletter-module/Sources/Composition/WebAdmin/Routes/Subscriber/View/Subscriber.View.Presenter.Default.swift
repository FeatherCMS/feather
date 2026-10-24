import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Subscriber.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Subscriber.Router.Routes

        func render(
            model: Subscriber.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Subscriber details",
                content: Subscriber.View.Details(
                    model: model,
                    permissions: AdminListActions(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    routes: routes
                )
            )
        }

        func renderErrorPage(
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Subscriber details",
                content: AdminStatusView(
                    state: .init(
                        title: "Subscriber unavailable",
                        message: message
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }
    }
}
