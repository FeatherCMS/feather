import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssueDefaultController:
    AdminAddNewsletterIssueController
{
    let buildRuntime: RuntimeBuilder<
        any AdminAddNewsletterIssueInteractor,
        any AdminAddNewsletterIssuePresenter
    >
    func getAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            let newsletterId = context.parameters.get(
                "newsletterId",
                as: String.self
            )
        else {
            return HTMLResponse(content: "Bad request", status: .badRequest)
        }
        return try await presenter.renderPage(
            model: try await interactor.getAddNewsletterIssue(
                newsletterId: newsletterId
            ),
            permissions: context.currentUserPermissions
        )
    }
    func postAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            let newsletterId = context.parameters.get(
                "newsletterId",
                as: String.self
            )
        else {
            return Response(status: .badRequest)
        }
        let payload = try await request.decode(
            as: NewsletterIssueAddForm.self,
            context: context
        )
        let model = try await interactor.postAddNewsletterIssue(
            newsletterId: newsletterId,
            payload: payload
        )
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to:
                    NewsletterAdminRoutes.campaignIssues(
                        RouterPath(model.newsletterId)
                    )
                    .description,
                notification: .init(
                    title: "Added",
                    message: "Campaign issue added successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
