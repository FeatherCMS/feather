import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAssetDefaultController: AdminEditMediaAssetController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminEditMediaAssetInteractor,
            any AdminEditMediaAssetPresenter
        >

    func getEditMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let id = try request.requiredID()
        let permissions = context.currentUserAdminListActions
        do {
            let model = try await runtime.interactor.load(id: id)
            return try await runtime.presenter.renderEditPage(
                model: model,
                permissions: permissions
            )
        }
        catch {
            return try await runtime.presenter.renderErrorPage(
                id: id,
                info: "Asset not found.",
                message: error.displayMessage,
                permissions: permissions
            )
        }
    }

    func postEditMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let id = try request.requiredID()
        let permissions = context.currentUserAdminListActions
        let payload = try await request.decode(
            as: AssetEditForm.self,
            context: context
        )

        do {
            _ = try await runtime.interactor.update(id: id, input: payload)
            return AdminNotificationFlash.redirect(
                to: MediaAssetRoutes.edit(RouterPath(id)).description,
                notification: .init(
                    title: "Saved",
                    message: "Media asset edited successfully."
                )
            )
        }
        catch {
            let fallback = try? await runtime.interactor.load(id: id)
            let model = AdminEditMediaAssetModel(
                id: id,
                url: fallback?.url ?? "",
                extension: fallback?.extension ?? "",
                status: fallback?.status ?? "",
                sizeBytes: fallback?.sizeBytes ?? 0,
                title: payload.normalizedTitle ?? "",
                altText: payload.normalizedAltText ?? "",
                error: error.displayMessage
            )
            return try await runtime.presenter
                .renderEditPage(
                    model: model,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
