import Hummingbird

struct AdminEditMediaProcessorDefaultController:
    AdminEditMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditMediaProcessorInteractor,
            presenter: any AdminEditMediaProcessorPresenter
        )

    func getEditMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let model = try await interactor.getEditMediaProcessor(id: id)
            return presenter.renderPage(
                model: model,
                permissions: permissions
            )
        }
        catch {
            return presenter.renderPage(
                model: .init(
                    id: id,
                    fileSuffix: "",
                    matchExtensions: "",
                    commandTemplate: "",
                    error: error.displayMessage
                ),
                permissions: permissions
            )
        }
    }

    func postEditMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AddProcessorForm.self,
            context: context
        )
        let model = try await interactor.postEditMediaProcessor(
            id: id,
            payload: payload
        )
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/processors/",
                        title: "Saved",
                        message: "Processor edited successfully."
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
