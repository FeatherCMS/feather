import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetSystemVariableDefaultPresenter: AdminGetSystemVariablePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "System variable details - Feather CMS",
            description: "Management system variable details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemVariableDetails(
                state: .init(
                    variable: variable,
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
            title: "System variable details - Feather CMS",
            description: "Management system variable details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemVariableError(
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
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Variables", link: "/admin/system/variables/"),
            .init(label: "Details", link: "/admin/system/variables/\(id)/"),
        ])
    }
}
