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

extension Asset.File.View.Controller {
    struct Default: Asset.File.View.Controller.Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.File.View.Interactor.Interface,
                any Asset.File.View.Presenter.Interface
            >

        func getMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
}
