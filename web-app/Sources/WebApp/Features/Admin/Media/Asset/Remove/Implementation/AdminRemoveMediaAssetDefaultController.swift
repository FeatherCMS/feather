import Hummingbird

struct AdminRemoveMediaAssetDefaultController: AdminRemoveMediaAssetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveMediaAssetInteractor,
            presenter: any AdminRemoveMediaAssetPresenter
        )

    func getRemoveMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let model = try await interactor.getRemoveMediaAsset(id: id)
        return presenter.renderPage(
            model: model,
            permissions: permissions
        )
    }

    func postRemoveMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let model = try await interactor.postRemoveMediaAsset(id: id)
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/assets/",
                        title: "Removed",
                        message: "Item removed successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: permissions
            )
            .response(from: request, context: context)
    }
}
