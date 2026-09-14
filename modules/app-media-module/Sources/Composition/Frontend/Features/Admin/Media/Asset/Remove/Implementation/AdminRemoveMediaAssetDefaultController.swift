import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetDefaultController: AdminRemoveMediaAssetController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveMediaAssetInteractor,
            presenter: any AdminRemoveMediaAssetPresenter
        )

    func getRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let model = try await interactor.getRemoveMediaAsset(id: id)
        return try await presenter.renderPage(
            model: model
        )
    }

    func postRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let model = try await interactor.postRemoveMediaAsset(id: id)
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: MediaAssetRoutes.list.description,
                notification: .init(
                    title: "Removed",
                    message: "Media asset removed successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model
            )
            .response(from: request, context: context)
    }
}
