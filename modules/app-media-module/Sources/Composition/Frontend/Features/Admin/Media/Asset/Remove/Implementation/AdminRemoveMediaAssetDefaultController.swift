import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetDefaultController: AdminRemoveMediaAssetController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminRemoveMediaAssetInteractor,
            any AdminRemoveMediaAssetPresenter
        >

    func getRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        let model = try await interactor.getRemoveMediaAsset(id: id)
        return try await presenter.renderRemovePage(
            model: model
        )
    }

    func postRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(status: .badRequest)
        }
        let model = try await interactor.postRemoveMediaAsset(id: id)
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: MediaAssetRoutes.list.description,
                notification: .init(
                    title: "Removed",
                    message: "Media item removed successfully."
                )
            )
        }
        return
            try await presenter.renderRemovePage(
                model: model
            )
            .response(from: request, context: context)
    }
}
