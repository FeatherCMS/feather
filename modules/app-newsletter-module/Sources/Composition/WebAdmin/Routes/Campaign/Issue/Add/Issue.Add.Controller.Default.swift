import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Issue.Add.Interactor.Interface,
                any Issue.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            guard
                let newsletterId = context.parameters.get(
                    "newsletterId",
                    as: String.self
                )
            else {
                return HTMLResponse(
                    content: "Bad request",
                    status: .badRequest
                )
            }
            return try await runtime.presenter.renderPage(
                model: try await runtime.interactor.get(
                    newsletterId: newsletterId
                ),
                permissions: context.currentUserPermissions
            )
        }

        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                let newsletterId = context.parameters.get(
                    "newsletterId",
                    as: String.self
                )
            else {
                return Response(status: .badRequest)
            }
            let payload = try await request.decode(
                as: Issue.Form.Input.self,
                context: context
            )
            let model = try await runtime.interactor.add(
                newsletterId: newsletterId,
                payload: payload
            )
            if model.error == nil {
                return AdminNotification.redirect(
                    to: routes.issuesPath(newsletterId: model.newsletterId),
                    notification: .init(
                        title: "Added",
                        message: "Campaign issue added successfully."
                    )
                )
            }
            return try await runtime.presenter
                .renderPage(
                    model: model,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
