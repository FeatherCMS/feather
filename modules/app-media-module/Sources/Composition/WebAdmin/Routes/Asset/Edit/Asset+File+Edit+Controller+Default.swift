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

extension Asset.File.Edit.Controller {
    struct Default: Asset.File.Edit.Controller.Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.File.Edit.Interactor.Interface,
                any Asset.File.Edit.Presenter.Interface
            >
        let routes: Asset.Router.Routes

        func getEditMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
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
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserAdminListActions
            let payload = try await request.decode(
                as: AssetEditForm.self,
                context: context
            )

            do {
                _ = try await runtime.interactor.update(id: id, input: payload)
                return AdminNotificationFlash.redirect(
                    to: routes.file.editPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Media asset edited successfully."
                    )
                )
            }
            catch {
                let model = Asset.File.Edit.Model(
                    id: id,
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
}
