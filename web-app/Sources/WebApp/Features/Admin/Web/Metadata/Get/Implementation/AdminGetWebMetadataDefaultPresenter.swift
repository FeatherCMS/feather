import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetWebMetadataDefaultPresenter: AdminGetWebMetadataPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMetadataDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Web metadata details - Feather CMS",
            description: "Management web metadata details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMetadataDetails(
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
            title: "Web metadata details - Feather CMS",
            description: "Management web metadata details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMetadataError(
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
            .init(label: "Metadata", link: "/admin/web/metadata/"),
            .init(label: "Details", link: "/admin/web/metadata/\(id)/"),
        ])
    }
}
