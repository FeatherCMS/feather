import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebDomain
public import WebModule

extension Menu.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func renderEditPage(
            id: String,
            state: MenuForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuEdit(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: MenuRoutes.breadcrumb
                    )
                )
            )
        }

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: MenuRoutes.breadcrumb
                    )
                )
            )
        }

    }
}
