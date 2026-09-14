import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssueDefaultPresenter:
    AdminRemoveNewsletterIssuePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        -> HTMLResponse
    {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove campaign issue",
            description: "Remove campaign issue",
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
                        .init(
                            label: "Issues",
                            link: "/admin/newsletter/\(newsletterId)/issues/"
                        ),
                    ]),
                    title: "Remove campaign issue",
                    message:
                        "Are you sure you want to remove this issue? This action cannot be undone.",
                    submitLabel: "Remove issue",
                    actionURL:
                        "/admin/newsletter/\(newsletterId)/issues/\(issueId)/remove/",
                    cancelURL: "/admin/newsletter/\(newsletterId)/issues/"
                )
            )
        )
    }
}
