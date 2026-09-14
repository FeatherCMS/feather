import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(id: String, permissions: Set<String>) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove campaign",
            description: "Remove campaign",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminConfirmationDialog(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(
                            label: "Campaigns",
                            link: "/admin/newsletter/campaigns/"
                        ),
                    ]),
                    title: "Remove campaign",
                    message:
                        "Are you sure you want to remove this campaign? This action cannot be undone.",
                    submitLabel: "Remove campaign",
                    actionURL: "/admin/newsletter/\(id)/remove/",
                    cancelURL: "/admin/newsletter/campaigns/"
                )
            )
        )
    }
}
