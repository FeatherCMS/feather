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

struct AdminEditMediaFolderDefaultController: AdminEditMediaFolderController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminEditMediaFolderInteractor,
            any AdminEditMediaFolderPresenter
        >

    func getEditMediaFolder(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
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
                info: "Folder not found.",
                message: error.displayMessage,
                permissions: permissions
            )
        }
    }

    func postEditMediaFolder(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions
        let payload = try await request.decode(
            as: MediaFolderEditForm.self,
            context: context
        )

        do {
            _ = try await runtime.interactor.update(id: id, input: payload)
            return AdminNotificationFlash.redirect(
                to: MediaFolderRoutes.edit(RouterPath(id)).description,
                notification: .init(
                    title: "Saved",
                    message: "Media folder edited successfully."
                )
            )
        }
        catch {
            let fallback = try? await runtime.interactor.load(id: id)
            let model = AdminEditMediaFolderModel(
                id: id,
                parentId: fallback?.parentId,
                name: payload.normalizedName,
                slug: fallback?.slug ?? "",
                slugPath: fallback?.slugPath ?? "",
                assetCount: fallback?.assetCount ?? 0,
                totalSizeBytes: fallback?.totalSizeBytes ?? 0,
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
