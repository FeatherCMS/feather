import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Issue.TestEmail.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Campaign.Router.Routes

        func send(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
        {
            guard context.isCurrentUserAllowed(to: Issue.Permissions.update)
            else { return Response(status: .forbidden) }
            let newsletterKey = try context.requiredParameter("newsletterId")
            let issueId = context.parameters.get("issueId", as: String.self)
            let location = issueId.map {
                routes.issueEditPath(newsletterId: newsletterKey, issueId: $0)
            } ?? routes.issueAddPath(newsletterId: newsletterKey)

            do {
                let form = try await request.decode(
                    as: Issue.TestEmail.Form.self,
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
                let api = API.Client(
                    environment: environment,
                    requestContext: context
                )

                if let issueId {
                    let response = try await api.newsletterIssueTestEmail(
                        path: .init(
                            newsletterCampaignKey: newsletterKey,
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
                } else {
                    let response = try await api.newsletterCampaignTestEmail(
                        path: .init(newsletterCampaignKey: newsletterKey),
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
            } catch {
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
}
