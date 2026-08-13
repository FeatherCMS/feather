import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterIssueDefaultController:
    AdminEditNewsletterIssueController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditNewsletterIssueInteractor,
            presenter: any AdminEditNewsletterIssuePresenter
        )
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        do {
            return presenter.render(
                model: try await interactor.get(
                    newsletterId: newsletterId,
                    issueId: issueId
                ),
                issueId: issueId,
                permissions: context.currentUserPermissions,
                error: nil
            )
        }
        catch {
            return presenter.render(
                model: .init(
                    subject: "",
                    content: "",
                    scheduledAt: "",
                    newsletterId: newsletterId,
                    error: nil
                ),
                issueId: issueId,
                permissions: context.currentUserPermissions,
                error: error.displayMessage
            )
        }
    }
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        let form = try await request.decode(
            as: NewsletterIssueAddForm.self,
            context: context
        )
        do {
            try await interactor.update(
                newsletterId: newsletterId,
                issueId: issueId,
                form: form
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
            return
                try presenter.render(
                    model: .init(
                        subject: form.subject,
                        content: form.content,
                        scheduledAt: form.scheduledAt,
                        newsletterId: newsletterId,
                        error: error.displayMessage
                    ),
                    issueId: issueId,
                    permissions: context.currentUserPermissions,
                    error: error.displayMessage
                )
                .response(from: request, context: context)
        }
    }
}
