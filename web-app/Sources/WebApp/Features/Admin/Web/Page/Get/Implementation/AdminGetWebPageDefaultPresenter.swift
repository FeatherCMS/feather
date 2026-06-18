import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetWebPageDefaultPresenter: AdminGetWebPagePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Web page details - Feather CMS",
            description: "Management web page details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebPageDetails(
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
            title: "Web page details - Feather CMS",
            description: "Management web page details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebPageError(
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
            .init(label: "Web", link: "/admin/web/"),
            .init(label: "Pages", link: "/admin/web/pages/"),
            .init(label: "Details", link: "/admin/web/pages/\(id)/"),
        ])
    }
}
