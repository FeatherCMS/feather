import Hummingbird

struct AdminAddContactNewsletterDefaultController:
    AdminAddContactNewsletterController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddContactNewsletterInteractor,
            presenter: any AdminAddContactNewsletterPresenter
        )

    func getAddContactNewsletter(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getAddContactNewsletter(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddContactNewsletter(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ContactNewsletterAddForm.self,
            context: context
        )
        let model = try await interactor.postAddContactNewsletter(
            payload: payload
        )
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/newsletters/",
                        title: "Added",
                        message: "Campaign added successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
