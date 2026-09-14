import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactSubmissionsDefaultPresenter:
    AdminListContactSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Contact submissions",
            description: "View all contact form submissions",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
