import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func renderEditPage(
            authorID: String,
            id: String,
            state: BlogAuthorLinkForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit blog author link",
                content: AuthorLink.Edit.Component(
                    state: .init(
                        authorID: authorID,
                        id: id,
                        form: state,
                        breadcrumb: routes.authorLinksBreadcrumb(
                            RouterPath(authorID)
                        ),
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            authorID: String,
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit blog author link",
                content: BlogAuthorLinkError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.authorLinksBreadcrumb(
                            RouterPath(authorID)
                        )
                    )
                )
            )
        }

    }
}
