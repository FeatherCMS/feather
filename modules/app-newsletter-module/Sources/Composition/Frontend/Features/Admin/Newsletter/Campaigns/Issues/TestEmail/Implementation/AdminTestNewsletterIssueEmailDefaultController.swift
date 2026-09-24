import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminTestNewsletterIssueEmailDefaultController:
    AdminTestNewsletterIssueEmailController
{
    let apiBuilder: NewsletterAPIBuilder
    func send(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let newsletterId = try request.requiredParameter("newsletterId")
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
            _ = try await apiBuilder.makeNewsletterAdmin(context)
                .newsletterIssueTestEmail(
                    path: .init(
                        newsletterCampaignId: newsletterId,
                        newsletterIssueId: issueId
                    ),
                    body: body
                )
        }
        else {
            _ = try await apiBuilder.makeNewsletterAdmin(context)
                .newsletterCampaignTestEmail(
                    path: .init(newsletterCampaignId: newsletterId),
                    body: body
                )
        }
        return AdminNotificationFlash.redirect(
            to: issueId.map {
                NewsletterAdminRoutes.issueEdit(
                    newsletterID: RouterPath(newsletterId),
                    issueID: RouterPath($0)
                )
                .description
            }
                ?? NewsletterAdminRoutes.issueAdd(RouterPath(newsletterId))
                .description,
            notification: .init(
                title: "Sent",
                message: "Test email queued successfully."
            )
        )
    }
}
