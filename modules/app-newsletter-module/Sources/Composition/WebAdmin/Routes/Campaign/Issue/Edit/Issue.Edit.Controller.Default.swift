import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Edit.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Issue.Edit.Interactor.Interface,
                any Issue.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let issueId = try context.requiredParameter("issueId")

            do {
                return try await runtime.presenter.renderPage(
                    model: try await runtime.interactor.get(
                        newsletterId: newsletterId,
                        issueId: issueId
                    ),
                    issueId: issueId,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await runtime.presenter.renderPage(
                    model: .init(
                        subject: "",
                        content: "",
                        scheduledAt: "",
                        newsletterId: newsletterId,
                        error: error.displayMessage
                    ),
                    issueId: issueId,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func edit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let issueId = try context.requiredParameter("issueId")
            let form = try await request.decode(
                as: Issue.Form.Input.self,
                context: context
            )

            do {
                try await runtime.interactor.edit(
                    newsletterId: newsletterId,
                    issueId: issueId,
                    form: form
                )
                return AdminNotification.redirect(
                    to: routes.issueEditPath(
                        newsletterId: newsletterId,
                        issueId: issueId
                    ),
                    notification: .init(
                        title: "Updated",
                        message: "Campaign issue updated successfully."
                    )
                )
            }
            catch {
                return try await runtime.presenter
                    .renderPage(
                        model: .init(
                            subject: form.subject,
                            content: form.content,
                            scheduledAt: form.scheduledAt,
                            newsletterId: newsletterId,
                            error: error.displayMessage
                        ),
                        issueId: issueId,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }

        func send(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            guard context.isCurrentUserAllowed(to: Issue.Permissions.update)
            else { return Response(status: .forbidden) }
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let issueId = try context.requiredParameter("issueId")

            do {
                let form = try await request.decode(
                    as: Issue.Form.Input.self,
                    context: context
                )
                try await runtime.interactor.edit(
                    newsletterId: newsletterId,
                    issueId: issueId,
                    form: .init(
                        subject: form.subject,
                        content: form.content,
                        scheduledAt: ""
                    )
                )
                return AdminNotification.redirect(
                    to: routes.issueEditPath(
                        newsletterId: newsletterId,
                        issueId: issueId
                    ),
                    notification: .init(
                        title: "Queued",
                        message:
                            "Issue deliveries have been queued for immediate delivery to subscribed recipients."
                    )
                )
            }
            catch {
                return AdminNotification.redirect(
                    to: routes.issueEditPath(
                        newsletterId: newsletterId,
                        issueId: issueId
                    ),
                    notification: .init(
                        title: "Unable to queue issue",
                        message: error.displayMessage
                    )
                )
            }
        }
    }
}
