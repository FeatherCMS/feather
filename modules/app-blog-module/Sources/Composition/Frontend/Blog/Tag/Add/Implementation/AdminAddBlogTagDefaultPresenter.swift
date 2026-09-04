import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminAddBlogTagDefaultPresenter: AdminAddBlogTagPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogTagForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add tag",
            description: "Add a tag in management",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagAdd(
                state: .init(
                    form: state,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Tags", link: "/admin/blog/tags/"),
                .init(label: "Add", link: "/admin/blog/tags/add/"),
            ]
        )
    }
}
