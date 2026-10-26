import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.View.Interactor.Interface,
                any Campaign.Subscriber.View.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            return try await runtime.presenter.render(
                newsletterId: context.requiredParameter("newsletterId"),
                item: try await runtime.interactor.get(
                    newsletterId: context.requiredParameter("newsletterId"),
                    subscriberId: context.requiredParameter("subscriberId")
                )
            )
        }
    }
}
