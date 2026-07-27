import Hummingbird

struct AdminAddMediaProcessorDefaultController:
    AdminAddMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddMediaProcessorInteractor,
            presenter: any AdminAddMediaProcessorPresenter
        )

    func getAddMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getAddMediaProcessor(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: AddProcessorForm.self,
            context: context
        )
        let model = try await interactor.postAddMediaProcessor(
            payload: payload
        )
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/processors/",
                        title: "Added",
                        message: "Processor added successfully."
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
