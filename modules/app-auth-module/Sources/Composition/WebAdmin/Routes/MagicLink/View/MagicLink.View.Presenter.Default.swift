import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension MagicLink.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: MagicLink.Router.Routes

        func renderPage(
            link: MagicLink.View.Detail,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User magic link details",
                content: MagicLink.View.Details(
                    state: .init(
                        link: link,
                        permissions: permissions,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

        func renderError(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User magic link details",
                content: MagicLink.View.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }
    }
}
