import AdminOpenAPI
import Hummingbird

struct AdminRemoveNewsletterIssueDefaultController:
    AdminRemoveNewsletterIssueController
{
    let renderingEngine: any RenderingEngine

    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(
                label: "Issues",
                link: "/admin/newsletters/\(newsletterId)/issues/"
            ),
        ])
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Remove campaign issue - Feather CMS",
            description: "Remove campaign issue",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: context.currentUserPermissions
            ),
            content: AdminConfirmationDialog(
                state: .init(
                    breadcrumb: breadcrumb,
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

    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        _ = try await context.managementAPI()
            .contactNewsletterIssueDelete(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                )
            )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/newsletters/\(newsletterId)/issues/",
                    title: "Removed",
                    message: "Campaign issue removed successfully."
                )
            ]
        )
    }
}
