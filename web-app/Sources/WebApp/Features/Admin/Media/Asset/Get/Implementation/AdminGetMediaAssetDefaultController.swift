import Hummingbird

struct AdminGetMediaAssetDefaultController: AdminGetMediaAssetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetMediaAssetInteractor,
            presenter: any AdminGetMediaAssetPresenter
        )

    func getMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let model = try await interactor.getMediaAsset(id: id)
            return presenter.renderPage(
                model: model,
                id: id,
                permissions: permissions,
                error: nil
            )
        }
        catch {
            return presenter.renderPage(
                model: nil,
                id: id,
                permissions: permissions,
                error: error.displayMessage
            )
        }
    }
}
