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

extension AuthorLink.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func render(
            authorID: String,
            state: BlogAuthorLinkForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add blog author link",
                content: AuthorLink.Add.Component(
                    state: .init(
                        authorID: authorID,
                        form: state,
                        breadcrumb: routes.authorLinksBreadcrumb(
                            RouterPath(authorID)
                        ),
                        routes: routes
                    )
                )
            )
        }
    }
}
