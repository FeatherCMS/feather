import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Add.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.Add.Interactor.Interface,
                any Campaign.Subscriber.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            try await buildRuntime(request, context).presenter
                .render(
                    newsletterId: try context.requiredParameter("newsletterId"),
                    form: .init(
                        email: "",
                        firstName: "",
                        lastName: "",
                        status: "subscribed"
                    ),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let form = try await request.decode(
                as: Campaign.Subscriber.Form.Input.self,
                context: context
            )
            do {
                try await runtime.interactor.create(
                    newsletterId: newsletterId,
                    form: form
                )
                return AdminNotificationFlash.redirect(
                    to: routes.subscribersPath(newsletterId: newsletterId),
                    notification: .init(
                        title: "Added",
                        message: "Subscriber added successfully."
                    )
                )
            }
            catch {
                return try await runtime.presenter
                    .render(
                        newsletterId: newsletterId,
                        form: form,
                        error: error.displayMessage,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
