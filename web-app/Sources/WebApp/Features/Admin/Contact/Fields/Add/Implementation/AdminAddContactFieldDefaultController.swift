import Hummingbird

struct AdminAddContactFieldDefaultController:
    AdminAddContactFieldController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddContactFieldInteractor,
            presenter: any AdminAddContactFieldPresenter
        )
    func getAddContactField(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getAddContactField(),
            permissions: context.currentUserPermissions
        )
    }
    func postAddContactField(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ContactFieldFormInput.self,
            context: context
        )
        let model = try await interactor.postAddContactField(payload: payload)
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/contact/fields/",
                        title: "Added",
                        message: "Form field added successfully."
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
