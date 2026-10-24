import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import NewsApplication
import NewsModule

extension Category.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let mediaAPI: MediaWebAdmin.API.Client
        let renderingEngine: any RenderingEngine
        let routes: Category.Router.Routes

        func renderForm(
            input: Category.Form.Input,
            error: String?,
            title: String,
            action: String,
            submitLabel: String,
            removeHref: String?
        ) async throws -> HTMLResponse {
            let selectedImageAsset = try? await mediaAPI.loadImageAsset(
                assetId: input.imageAssetId
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
                    removeHref: removeHref,
                    routes: routes
                )
            )
        }

        func renderError(_ message: String) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News category",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News category unavailable",
                    message: message
                )
            )
        }

        func renderUpdated(id: String) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "News category updated successfully."
                )
            )
        }
    }
}
