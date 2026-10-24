import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

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

    }
}
