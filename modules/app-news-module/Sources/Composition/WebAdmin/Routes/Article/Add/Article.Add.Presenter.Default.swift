import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import NewsApplication
import NewsModule

extension Article.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let mediaRepository:
            any MediaModule.Asset.File.View.Repository.Interface
        let renderingEngine: any RenderingEngine
        let routes: Article.Router.Routes

        func renderForm(
            input: Article.Form.Input,
            categories: [Article.Form.CategoryOption],
            error: String?,
            title: String,
            action: String,
            submitLabel: String,
            moreActions: [AdminButton.State]
        ) async throws -> HTMLResponse {
            let selectedImageAsset = try? await mediaRepository.loadImageAsset(
                assetId: input.imageAssetId,
                variants: ["preview"]
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: title,
                content: Article.Form.Page(
                    input: input,
                    selectedImageAsset: selectedImageAsset,
                    categories: categories,
                    error: error,
                    title: title,
                    action: action,
                    submitLabel: submitLabel,
                    moreActions: moreActions,
                    routes: routes
                )
            )
        }

        func renderCreated() -> Response {
            AdminNotification.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "News article added successfully."
                )
            )
        }
    }
}
