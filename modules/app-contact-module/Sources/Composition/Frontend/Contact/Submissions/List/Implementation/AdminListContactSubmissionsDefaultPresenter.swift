import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactSubmissionsDefaultPresenter:
    AdminListContactSubmissionsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact submissions - Feather CMS",
            description: "View all contact form submissions",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminContactSubmissionsDirectoryView(
                items: items,
                search: search,
                canRemove: permissions.contains(
                    "contact:form-submissions:delete"
                ),
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Submissions", link: ""),
                ]),
                error: error
            )
        )
    }
}
