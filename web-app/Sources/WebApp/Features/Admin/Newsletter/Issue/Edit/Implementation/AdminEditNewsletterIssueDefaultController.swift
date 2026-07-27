import AdminOpenAPI
import Hummingbird

struct AdminEditNewsletterIssueDefaultController:
    AdminEditNewsletterIssueController
{
    let renderingEngine: any RenderingEngine

    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        let response = try await context.managementAPI()
            .contactNewsletterIssueGet(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                )
            )
        guard case .ok(let value) = response else {
            return HTMLResponse(
                content: "Unable to load issue",
                status: .notFound
            )
        }
        let issue = try value.body.json
        return renderForm(
            request: request,
            permissions: context.currentUserPermissions,
            newsletterId: newsletterId,
            issueId: issueId,
            subject: issue.subject,
            content: issue.content,
            scheduledAt: issue.scheduledAt.map { String(describing: $0) } ?? "",
            error: nil
        )
    }

    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        let form = try await request.decode(
            as: ContactNewsletterIssueAddForm.self,
            context: context
        )
        do {
            _ = try await context.managementAPI()
                .contactNewsletterIssueUpdate(
                    path: .init(
                        contactNewsletterId: newsletterId,
                        contactNewsletterIssueId: issueId
                    ),
                    body: .json(
                        .init(
                            subject: form.normalizedSubject,
                            content: form.content,
                            scheduledAt: Double(form.scheduledAt)
                        )
                    )
                )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath:
                            "/admin/newsletters/\(newsletterId)/issues/",
                        title: "Updated",
                        message: "Campaign issue updated successfully."
                    )
                ]
            )
        }
        catch {
            return try renderForm(
                request: request,
                permissions: context.currentUserPermissions,
                newsletterId: newsletterId,
                issueId: issueId,
                subject: form.subject,
                content: form.content,
                scheduledAt: form.scheduledAt,
                error: error.displayMessage
            )
            .response(from: request, context: context)
        }
    }

    private func renderForm(
        request: Request,
        permissions: Set<String>,
        newsletterId: String,
        issueId: String?,
        subject: String,
        content: String,
        scheduledAt: String,
        error: String?
    ) -> HTMLResponse {
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
            title: "Edit campaign issue - Feather CMS",
            description: "Edit campaign issue",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactNewsletterIssueAddView(
                state: .init(
                    subject: subject,
                    content: content,
                    scheduledAt: scheduledAt,
                    newsletterId: newsletterId,
                    issueId: issueId,
                    error: error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
