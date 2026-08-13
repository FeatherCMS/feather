import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebStandards

struct AdminListSystemJobDefaultPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminListSystemJobModel,
        search: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Worker jobs - Feather CMS",
            description: "Inspect worker jobs",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemJobTable(
                state: .init(
                    jobs: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search,
                    permissions: permissions,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderError(error: String, permissions: Set<String>) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Worker jobs - Feather CMS",
            description: "Inspect worker jobs",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemJobError(message: error, breadcrumb: breadcrumb())
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Worker jobs", link: "/admin/system/jobs/"),
        ])
    }
}
