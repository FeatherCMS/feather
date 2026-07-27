import Hummingbird

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(id: String, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove campaign - Feather CMS",
            description: "Remove campaign",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminConfirmationDialog(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                    ]),
                    title: "Remove campaign",
                    message:
                        "Are you sure you want to remove this campaign? This action cannot be undone.",
                    submitLabel: "Remove campaign",
                    actionURL: "/admin/newsletters/\(id)/remove/",
                    cancelURL: "/admin/newsletters/"
                )
            )
        )
    }
}
