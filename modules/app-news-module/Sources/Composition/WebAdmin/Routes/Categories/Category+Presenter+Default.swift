import NewsApplication
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import NewsAdminAPI
import NewsModule

extension Category {
    enum Presenter {}
}

extension Category.Presenter {
    struct Default: Category.Detail.Presenter.Interface,
        Category.Edit.Presenter.Interface,
        Category.Remove.Presenter.Interface
    {
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

        func renderDetails(
            item: Components.Schemas.NewsCategoryDetailSchema
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: item.title,
                content: Category.Detail.Page(
                    item: item,
                    permissions: context.currentUserAdminListActions,
                    routes: routes
                )
            )
        }

        func renderError(
            _ message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News category",
                content: NewsErrorPage(
                    breadcrumb: routes.breadcrumb,
                    title: "News category unavailable",
                    message: message
                )
            )
        }

        func renderRemoveConfirmation(
            item: Components.Schemas.NewsCategoryDetailSchema
        ) async throws -> Response {
            let nonce = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return
                try await renderingEngine.renderAdminDialog(
                    request: request,
                    context: context,
                    title: AdminRemoveConfirmation.dialogTitle,
                    content: AdminRemoveConfirmation(
                        header: .primary(
                            title: "Remove news category",
                            description: "This action cannot be undone."
                        ),
                        selectedItems: [item.title],
                        action: routes.removePath(item.id),
                        nonceToken: nonce,
                        hiddenFields: [.init(name: "id", value: item.id)]
                    ),
                    size: .small
                )
                .response(from: request, context: context)
        }

        func renderUpdated(
            id: String
        ) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "News category updated successfully."
                )
            )
        }

        func renderRemoved() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Removed",
                    message: "News category removed successfully."
                )
            )
        }
    }
}
