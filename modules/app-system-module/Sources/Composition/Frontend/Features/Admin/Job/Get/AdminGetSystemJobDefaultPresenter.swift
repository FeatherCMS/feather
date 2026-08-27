import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import WebStandards

struct AdminGetSystemJobDefaultPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        job: Components.Schemas.SystemJobSchema,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Worker job details - Feather CMS",
            description: "Inspect a worker job",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemJobDetails(
                job: job,
                breadcrumb: breadcrumb(id: job.id)
            )
        )
    }

    func renderError(error: String, permissions: Set<String>) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Worker job details - Feather CMS",
            description: "Inspect a worker job",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemJobError(
                message: error,
                breadcrumb: breadcrumb(id: "")
            )
        )
    }

    private func breadcrumb(id: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Worker jobs", link: "/admin/system/jobs/"),
            .init(label: "Details", link: "/admin/system/jobs/\(id)/"),
        ])
    }
}
