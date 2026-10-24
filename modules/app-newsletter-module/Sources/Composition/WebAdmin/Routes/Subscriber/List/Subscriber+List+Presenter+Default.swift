import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule
import NewsletterApplication

extension Subscriber.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Subscriber.Router.Routes

        func render(
            model: Subscriber.List.Model,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(
                Set(permissions.map(PermissionKey.init))
            )
            if let error {
                return try await renderingEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Subscribers",
                    content: AdminStatusView(
                        state: .init(
                            title: "Subscribers unavailable",
                            message: error
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Subscribers",
                content: Subscriber.List.Table(
                    model: model,
                    permissions: actions,
                    routes: routes
                )
            )
        }

        func renderDetailsPage(
            item: Subscriber.List.Model.Item,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Subscriber details",
                content: Subscriber.List.Details(
                    item: item,
                    permissions: AdminListActions(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    routes: routes
                )
            )
        }

        func renderDetailsErrorPage(
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
