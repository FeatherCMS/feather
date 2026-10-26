import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import NewsApplication
import NewsModule

extension Category.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let mediaRepository:
            any MediaModule.Asset.File.View.Repository.Interface
        let renderingEngine: any RenderingEngine
        let routes: Category.Router.Routes

        func renderForm(
            input: Category.Form.Input,
            error: String?,
            title: String,
            action: String,
            submitLabel: String
        ) async throws -> HTMLResponse {
            let selectedImageAsset = try? await mediaRepository.loadImageAsset(
                assetId: input.imageAssetId,
                variants: ["preview"]
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: title,
                content: Category.Form.Page(
                    input: input,
                    selectedImageAsset: selectedImageAsset,
                    error: error,
                    title: title,
                    action: action,
                    submitLabel: submitLabel,
                    moreActions: [],
                    routes: routes
                )
            )
        }

        func renderCreated() -> Response {
            AdminNotification.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "News category added successfully."
                )
            )
        }
    }
}
