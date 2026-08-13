import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterIssueDefaultPresenter:
    AdminRemoveNewsletterIssuePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        -> HTMLResponse
    {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove campaign issue - Feather CMS",
            description: "Remove campaign issue",
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
                        .init(
                            label: "Issues",
                            link: "/admin/newsletters/\(newsletterId)/issues/"
                        ),
                    ]),
                    title: "Remove campaign issue",
                    message:
                        "Are you sure you want to remove this issue? This action cannot be undone.",
                    submitLabel: "Remove issue",
                    actionURL:
                        "/admin/newsletters/\(newsletterId)/issues/\(issueId)/remove/",
                    cancelURL: "/admin/newsletters/\(newsletterId)/issues/"
                )
            )
        )
    }
}
