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
import WebStandards

struct AdminGetBlogAuthorLinkDefaultPresenter: AdminGetBlogAuthorLinkPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogAuthorLinkDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog author link details",
            description: "Management blog author link details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog author link details",
            description: "Management blog author link details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Blog", link: "/admin/blog/"),
            .init(label: "Authors", link: "/admin/blog/authors/"),
            .init(label: "Author", link: "/admin/blog/authors/\(menuId)/"),
            .init(label: "Links", link: "/admin/blog/authors/\(menuId)/links/"),
            .init(
                label: "Details",
                link: "/admin/blog/authors/\(menuId)/links/\(id)/"
            ),
        ])
    }
}
