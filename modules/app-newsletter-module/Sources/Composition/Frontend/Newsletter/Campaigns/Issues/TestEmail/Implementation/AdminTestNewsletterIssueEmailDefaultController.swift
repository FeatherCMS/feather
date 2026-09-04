import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminTestNewsletterIssueEmailDefaultController:
    AdminTestNewsletterIssueEmailController
{
    func send(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = context.parameters.get("issueId", as: String.self)
        let form = try await request.decode(
            as: NewsletterIssueTestEmailForm.self,
            context: context
        )
        let body = Components.RequestBodies
            .NewsletterIssueTestEmailRequestBody.json(
                .init(
                    email: form.email,
                    subject: form.subject,
                    content: form.content
                )
            )
        if let issueId {
            _ = try await context.newsletterAdminAPI()
                .newsletterIssueTestEmail(
                    path: .init(
                        newsletterCampaignId: newsletterId,
                        newsletterIssueId: issueId
                    ),
                    body: body
                )
        }
        else {
            _ = try await context.newsletterAdminAPI()
                .newsletterCampaignTestEmail(
                    path: .init(newsletterCampaignId: newsletterId),
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
