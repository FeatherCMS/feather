import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Edit.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.Edit.Interactor.Interface,
                any Campaign.Subscriber.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let subscriberId = try context.requiredParameter("subscriberId")
            do {
                let item = try await runtime.interactor.get(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId
                )
                return try await runtime.presenter.render(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId,
                    form: .init(
                        email: item.email,
                        firstName: item.firstName,
                        lastName: item.lastName,
                        status: item.status
                    ),
                    error: nil
                )
            }
            catch {
                return try await runtime.presenter.render(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId,
                    form: .init(
                        email: "",
                        firstName: "",
                        lastName: "",
                        status: "subscribed"
                    ),
                    error: error.displayMessage
                )
            }
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let subscriberId = try context.requiredParameter("subscriberId")
            let form = try await request.decode(
                as: Campaign.Subscriber.Form.Input.self,
                context: context
            )
            do {
                try await runtime.interactor.update(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId,
                    form: form
                )
                return AdminNotification.redirect(
                    to: routes.subscriberEditPath(
                        newsletterId: newsletterId,
                        subscriberId: subscriberId
                    ),
                    notification: .init(
                        title: "Updated",
                        message: "Subscriber updated successfully."
                    )
                )
            }
            catch {
                return try await runtime.presenter
                    .render(
                        newsletterId: newsletterId,
                        subscriberId: subscriberId,
                        form: form,
                        error: error.displayMessage
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
