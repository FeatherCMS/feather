import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail.Controller {
    struct Default: Interface {
        let repository:
            @Sendable (
                AuthenticatedRequestContext
            ) -> any Issue.TestEmail.Repository.Interface
        let routes: Campaign.Router.Routes
        let renderingEngine: any RenderingEngine

        func get(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        {
            guard context.isCurrentUserAllowed(to: Issue.Permissions.update)
            else {
                return HTMLResponse(content: "Forbidden", status: .forbidden)
            }
            let newsletterKey = try context.requiredParameter("newsletterId")
            let issueId = context.parameters.get("issueId", as: String.self)
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: "Send test email",
                content: Issue.TestEmail.Dialog(
                    newsletterId: newsletterKey,
                    issueId: issueId,
                    routes: routes
                ),
                size: .small
            )
        }

        func send(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
        {
            guard context.isCurrentUserAllowed(to: Issue.Permissions.update)
            else { return Response(status: .forbidden) }
            let newsletterKey = try context.requiredParameter("newsletterId")
            let issueId = context.parameters.get("issueId", as: String.self)
            let location =
                issueId.map {
                    routes.issueEditPath(
                        newsletterId: newsletterKey,
                        issueId: $0
                    )
                } ?? routes.issueAddPath(newsletterId: newsletterKey)

            do {
                let form = try await request.decode(
                    as: Issue.TestEmail.Form.self,
                    context: context
                )
                try await repository(context)
                    .send(
                        newsletterKey: newsletterKey,
                        issueID: issueId,
                        email: form.email,
                        subject: form.subject,
                        content: form.content
                    )

                return AdminNotification.redirect(
                    to: location,
                    notification: .init(
                        title: "Sent",
                        message: "Test email queued successfully."
                    )
                )
            }
            catch {
                return AdminNotification.redirect(
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
