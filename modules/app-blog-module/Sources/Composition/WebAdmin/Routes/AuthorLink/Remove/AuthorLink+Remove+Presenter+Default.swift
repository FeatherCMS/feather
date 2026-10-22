import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func renderError(
            authorID: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove blog author link",
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
