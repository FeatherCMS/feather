import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterSubscribersDefaultPresenter:
    AdminRemoveNewsletterSubscribersPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        ids: [String],
        search: String?,
        campaignId: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove subscribers - Feather CMS",
            description: "Confirm subscriber removal",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                        .init(
                            label: "Subscribers",
                            link: "/admin/newsletters/subscribers/"
                        ),
                    ]),
                    title: "Remove selected subscribers",
                    message:
                        "Are you sure you want to remove the selected subscribers? This action cannot be undone.",
                    action: "/admin/newsletters/subscribers/remove/",
                    cancelLink: "/admin/newsletters/subscribers/",
                    selectedIds: ids
                )
            )
        )
    }
}
