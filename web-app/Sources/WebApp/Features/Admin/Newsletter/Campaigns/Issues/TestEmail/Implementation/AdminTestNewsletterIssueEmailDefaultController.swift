import AdminOpenAPI
import Hummingbird

struct AdminTestNewsletterIssueEmailDefaultController:
    AdminTestNewsletterIssueEmailController
{
    func send(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = context.parameters.get("issueId", as: String.self)
        let form = try await request.decode(
            as: NewsletterIssueTestEmailForm.self,
            context: context
        )
        let body = Components.RequestBodies
            .ContactNewsletterIssueTestEmailRequestBody.json(
                .init(
                    email: form.email,
                    subject: form.subject,
                    content: form.content
                )
            )
        if let issueId {
            _ = try await context.managementAPI()
                .contactNewsletterIssueTestEmail(
                    path: .init(
                        contactNewsletterId: newsletterId,
                        contactNewsletterIssueId: issueId
                    ),
                    body: body
                )
        }
        else {
            _ = try await context.managementAPI()
                .contactNewsletterTestEmail(
                    path: .init(contactNewsletterId: newsletterId),
                    body: body
                )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: issueId.map {
                        "/admin/newsletters/\(newsletterId)/issues/\($0)/edit/"
                    } ?? "/admin/newsletters/\(newsletterId)/issues/add/",
                    title: "Sent",
                    message: "Test email queued successfully."
                )
            ]
        )
    }
}
