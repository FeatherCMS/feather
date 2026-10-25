import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import NewsApplication
import NewsModule

extension Article.Edit.Presenter {
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

        func renderError(_ message: String) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News article",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News article unavailable",
                    message: message
                )
            )
        }

        func renderUpdated(id: String) -> Response {
            AdminNotification.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "News article updated successfully."
                )
            )
        }
    }
}
