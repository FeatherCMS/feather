import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Session.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Session.Router.Routes

        func render(
            model: Session.List.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Sessions",
                content: Session.List.Page(
                    state: .init(
                        identityID: model.identityID,
                        items: model.items,
                        canRemove: permissions.contains(
                            Session.Permissions.delete.rawValue
                        ),
                        routes: routes
                    )
                )
            )
        }

        func renderError(
            error: OpenAPIRepositoryError,
            identityID: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: error.errorTitle,
                content: AdminStatusView(
                    state: .init(
                        title: error.errorTitle,
                        message: error.errorDescription
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
    }
}
