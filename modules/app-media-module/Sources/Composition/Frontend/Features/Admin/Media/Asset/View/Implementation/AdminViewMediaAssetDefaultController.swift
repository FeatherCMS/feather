import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaAssetDefaultController: AdminViewMediaAssetController {
    let buildRuntime: RuntimeBuilder<
        any AdminViewMediaAssetInteractor,
        any AdminViewMediaAssetPresenter
    >

    func getMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions
        do {
            let model = try await interactor.getMediaAsset(id: id)
            return try await presenter.renderDetailsPage(
                model: model,
                id: id,
                permissions: permissions,
                error: nil
            )
        }
        catch {
            return try await presenter.renderDetailsPage(
                model: nil,
                id: id,
                permissions: permissions,
                error: error.displayMessage
            )
        }
    }
}
