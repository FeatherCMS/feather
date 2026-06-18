import Hummingbird

struct AdminEditMediaFolderDefaultController: AdminEditMediaFolderController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditMediaFolderInteractor,
            presenter: any AdminEditMediaFolderPresenter
        )

    func getEditMediaFolder(
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
                info: "Folder not found.",
                message: error.displayMessage,
                permissions: permissions
            )
        }
    }

    func postEditMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let payload = try await request.decode(
            as: MediaFolderEditForm.self,
            context: context
        )

        do {
            _ = try await runtime.interactor.update(id: id, input: payload)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/folders/\(id)/edit/",
                        title: "Saved",
                        message: "Media folder edited successfully."
                    )
                ]
            )
        }
        catch {
            let fallback = try? await runtime.interactor.load(id: id)
            let model = AdminEditMediaFolderModel(
                id: id,
                parentId: fallback?.parentId,
                name: payload.normalizedName,
                path: fallback?.path ?? "",
                assetCount: fallback?.assetCount ?? 0,
                totalSizeBytes: fallback?.totalSizeBytes ?? 0,
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
