import Hummingbird

struct AdminGetNewsletterSubscriberDefaultController:
    AdminGetNewsletterSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetNewsletterSubscriberInteractor,
            presenter: any AdminGetNewsletterSubscriberPresenter
        )

    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let subscriberId = try context.requiredParameter("subscriberId")
        do {
            return presenter.render(
                model: try await interactor.get(
                    subscriberId: subscriberId,
                    newsletterId: request.queryString("campaignId")
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                subscriberId: subscriberId,
                newsletterId: request.queryString("campaignId") ?? "",
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
