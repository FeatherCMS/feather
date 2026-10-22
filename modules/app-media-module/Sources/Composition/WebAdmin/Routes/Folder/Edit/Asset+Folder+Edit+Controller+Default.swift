import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit.Controller {
    struct Default: Asset.Folder.Edit.Controller.Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Asset.Folder.Edit.Interactor.Interface,
                any Asset.Folder.Edit.Presenter.Interface
            >
        let routes: Asset.Router.Routes

        func getEditMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
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
            context: AuthenticatedRequestContext
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
                    to: routes.folder.editPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Media folder edited successfully."
                    )
                )
            }
            catch {
                let fallback = try? await runtime.interactor.load(id: id)
                let model = Asset.Folder.Edit.Model(
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
}
