import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactSubmissionsDefaultPresenter:
    AdminRemoveContactSubmissionsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderBulkConfirmation(selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
    {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact submissions - Feather CMS",
            description: "Remove contact submissions",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(
                            label: "Submissions",
                            link: "/admin/contact/submissions/"
                        ), .init(label: "Remove", link: ""),
                    ]),
                    title: "Remove contact submissions",
                    message:
                        "Are you sure you want to remove the selected contact submissions? This action cannot be undone.",
                    action: "/admin/contact/submissions/remove/",
                    cancelLink: "/admin/contact/submissions/",
                    selectedIds: selectedIds
                )
            )
        )
    }
}
