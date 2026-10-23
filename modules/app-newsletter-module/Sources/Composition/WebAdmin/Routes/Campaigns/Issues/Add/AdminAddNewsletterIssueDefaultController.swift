import FeatherWebAdmin
import FeatherWebShared
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
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddNewsletterIssueInteractor,
            any AdminAddNewsletterIssuePresenter
        >
    func getAddNewsletterIssue(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
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
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
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
