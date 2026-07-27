import Hummingbird

struct AdminEditNewsletterSubscriberDefaultController:
    AdminEditNewsletterSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditNewsletterSubscriberInteractor,
            presenter: any AdminEditNewsletterSubscriberPresenter
        )

    func edit(request: Request, context: AppRequestContext) async throws
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
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                model: .init(
                    newsletterId: request.queryString("campaignId") ?? "",
                    item: .init(
                        id: subscriberId,
                        email: "",
                        firstName: "",
                        lastName: "",
                        status: "subscribed"
                    )
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let subscriberId = try context.requiredParameter("subscriberId")
        let form = try await request.decode(
            as: NewsletterSubscriberForm.self,
            context: context
        )
        do {
            _ = try await interactor.update(
                subscriberId: subscriberId,
                newsletterId: request.queryString("campaignId"),
                form: form
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/newsletters/subscribers/",
                        title: "Updated",
                        message: "Subscriber updated successfully."
                    )
                ]
            )
        }
        catch {
            let model =
                (try? await interactor.get(
                    subscriberId: subscriberId,
                    newsletterId: request.queryString("campaignId")
                ))
                ?? .init(
                    newsletterId: request.queryString("campaignId") ?? "",
                    item: .init(
                        id: subscriberId,
                        email: form.email,
                        firstName: form.firstName,
                        lastName: form.lastName,
                        status: form.status
                    )
                )
            return
                try presenter.render(
                    model: model,
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
