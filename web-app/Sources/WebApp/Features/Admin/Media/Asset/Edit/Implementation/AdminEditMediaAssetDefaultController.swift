import Hummingbird

struct AdminEditMediaAssetDefaultController: AdminEditMediaAssetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditMediaAssetInteractor,
            presenter: any AdminEditMediaAssetPresenter
        )

    func getEditMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let model = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                model: model,
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: "Asset not found.",
                message: error.displayMessage,
                permissions: permissions
            )
        }
    }

    func postEditMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let payload = try await request.decode(
            as: AssetEditForm.self,
            context: context
        )

        do {
            _ = try await runtime.interactor.update(id: id, input: payload)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/assets/\(id)/edit/",
                        title: "Saved",
                        message: "Item edited successfully."
                    )
                ]
            )
        }
        catch {
            let fallback = try? await runtime.interactor.load(id: id)
            let model = AdminEditMediaAssetModel(
                id: id,
                storageKey: fallback?.storageKey ?? "",
                type: fallback?.type ?? "",
                status: fallback?.status ?? "",
                sizeBytes: fallback?.sizeBytes ?? 0,
                title: payload.normalizedTitle ?? "",
                altText: payload.normalizedAltText ?? "",
                error: error.displayMessage
            )
            return try runtime.presenter
                .renderEditPage(
                    model: model,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
