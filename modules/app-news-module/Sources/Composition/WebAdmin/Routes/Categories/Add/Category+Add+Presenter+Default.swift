import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import NewsModule

extension Category.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let mediaAPI: MediaAdminAPIClient
        let renderingEngine: any RenderingEngine
        let routes: Category.Router.Routes

        func renderForm(
            input: Category.Form.Input,
            error: String?,
            title: String,
            action: String,
            submitLabel: String
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
                    removeHref: nil,
                    routes: routes
                )
            )
        }

        func renderCreated() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "News category added successfully."
                )
            )
        }
    }
}
