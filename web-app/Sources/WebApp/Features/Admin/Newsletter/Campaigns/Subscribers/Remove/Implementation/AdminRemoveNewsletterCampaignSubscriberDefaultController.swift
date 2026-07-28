import Hummingbird

struct AdminRemoveNewsletterCampaignSubscriberDefaultController:
    AdminRemoveNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveNewsletterCampaignSubscriberInteractor,
            presenter: any AdminRemoveNewsletterCampaignSubscriberPresenter
        )
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        let item = try await interactor.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
        return presenter.render(
            newsletterId: newsletterId,
            subscriberId: subscriberId,
            email: item.email,
            permissions: context.currentUserPermissions
        )
    }
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberId: try context.requiredParameter("subscriberId")
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath:
                        "/admin/newsletters/\(newsletterId)/subscribers/",
                    title: "Removed",
                    message: "Subscriber removed successfully."
                )
            ]
        )
    }
    func removeSelected(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberIds: payload.normalizedSelectedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath:
                        "/admin/newsletters/\(newsletterId)/subscribers/",
                    title: "Removed",
                    message: "Subscribers removed successfully."
                )
            ]
        )
    }
}
