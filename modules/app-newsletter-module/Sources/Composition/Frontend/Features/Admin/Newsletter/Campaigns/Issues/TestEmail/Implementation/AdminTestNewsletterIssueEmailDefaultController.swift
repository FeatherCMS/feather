import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminTestNewsletterIssueEmailDefaultController:
    AdminTestNewsletterIssueEmailController
{
    func send(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        guard context.isCurrentUserAllowed(to: Permissions.Issues.update)
        else { return Response(status: .forbidden) }
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = context.parameters.get("issueId", as: String.self)
        let location = issueId.map {
            NewsletterAdminRoutes.issueEdit(
                newsletterID: RouterPath(newsletterId),
                issueID: RouterPath($0)
            ).description
        } ?? NewsletterAdminRoutes.issueAdd(RouterPath(newsletterId)).description
        do {
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
            let api = context.newsletterAdminAPI()
            if let issueId {
                let response = try await api.newsletterIssueTestEmail(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
                        newsletterIssueId: issueId
                    ),
                    body: body
                )
                switch response {
                case .noContent:
                    break
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            else {
                let response = try await api.newsletterCampaignTestEmail(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: body
                )
                switch response {
                case .noContent:
                    break
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Sent",
                    message: "Test email queued successfully."
                )
            )
        }
        catch {
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Test email failed",
                    message: error.displayMessage
                )
            )
        }
    }
}
