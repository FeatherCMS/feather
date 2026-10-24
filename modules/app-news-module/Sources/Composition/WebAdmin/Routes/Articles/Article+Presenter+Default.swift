import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import NewsAdminAPI
import NewsApplication
import NewsModule

extension NewsModule.Article {
    enum Presenter {}
}

extension Article.Presenter {
    struct Default: NewsModule.Article.Add.Presenter.Interface,
        NewsModule.Article.Detail.Presenter.Interface,
        NewsModule.Article.Edit.Presenter.Interface,
        NewsModule.Article.Remove.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let mediaAPI: MediaWebAdmin.API.Client
        let renderingEngine: any RenderingEngine
        let routes: NewsModule.Article.Router.Routes

        func renderForm(
            input: NewsModule.Article.Form.Input,
            categories: [NewsModule.Article.Form.CategoryOption],
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
                content: NewsModule.Article.Form.Page(
                    input: input,
                    selectedImageAsset: selectedImageAsset,
                    categories: categories,
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
            item: Components.Schemas.NewsArticleDetailSchema
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: item.title,
                content: NewsModule.Article.Detail.Page(
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
                title: "News article",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News article unavailable",
                    message: message
                )
            )
        }

        func renderRemoveConfirmation(
            item: Components.Schemas.NewsArticleDetailSchema
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
                            title: "Remove news article",
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

        func renderCreated() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "News article added successfully."
                )
            )
        }

        func renderUpdated(
            id: String
        ) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "News article updated successfully."
                )
            )
        }

        func renderRemoved() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Removed",
                    message: "News article removed successfully."
                )
            )
        }
    }
}
