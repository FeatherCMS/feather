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

struct AdminGetBlogTagDefaultPresenter: AdminGetBlogTagPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogTagDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog tag details - Feather CMS",
            description: "Management blog tag details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions,
                    isPublished: isPublished,
                    isUnpublished: isUnpublished
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
            title: "Blog tag details - Feather CMS",
            description: "Management blog tag details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Blog", link: "/admin/blog/"),
            .init(label: "Tags", link: "/admin/blog/tags/"),
            .init(label: "Details", link: "/admin/blog/tags/\(id)/"),
        ])
    }
}
