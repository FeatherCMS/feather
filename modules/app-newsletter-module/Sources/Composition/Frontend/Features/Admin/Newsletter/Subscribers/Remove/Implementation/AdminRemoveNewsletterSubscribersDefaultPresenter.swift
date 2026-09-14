import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersDefaultPresenter:
    AdminRemoveNewsletterSubscribersPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        ids: [String],
        search: String?,
        campaignId: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove subscribers",
            description: "Confirm subscriber removal",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(
                            label: "Campaigns",
                            link: "/admin/newsletter/campaigns/"
                        ),
                        .init(
                            label: "Subscribers",
                            link: "/admin/newsletter/subscribers/"
                        ),
                    ]),
                    title: "Remove selected subscribers",
                    message:
                        "Are you sure you want to remove the selected subscribers? This action cannot be undone.",
                    action: "/admin/newsletter/subscribers/remove/",
                    cancelLink: "/admin/newsletter/subscribers/",
                    selectedIds: ids
                )
            )
        )
    }
}
