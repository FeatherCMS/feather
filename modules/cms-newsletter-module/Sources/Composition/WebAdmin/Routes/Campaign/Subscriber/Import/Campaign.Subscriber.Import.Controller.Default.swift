import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Import.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.Import.Interactor.Interface,
                any Campaign.Subscriber.Import.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            try await buildRuntime(request, context).presenter
                .render(
                    newsletterId: try context.requiredParameter("newsletterId"),
                    error: nil
                )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            do {
                let form = try await request.decode(
                    as: Campaign.Subscriber.Import.Form.self,
                    context: context
                )
                let result = try await runtime.interactor.run(
                    newsletterId: newsletterId,
                    csv: form.csv
                )
                return AdminNotification.redirect(
                    to: routes.subscribersPath(newsletterId: newsletterId),
                    notification: .init(
                        title: "Import complete",
                        message:
                            "Added \(result.imported) subscribers; skipped \(result.skipped) existing or duplicate rows."
                    )
                )
            }
            catch {
                return try await runtime.presenter
                    .render(
                        newsletterId: newsletterId,
                        error: String(describing: error)
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
