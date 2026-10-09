import FeatherAdmin
import FeatherContracts
import Hummingbird
import MediaFrontend
import NewsAdminAPI
import NewsContracts

struct AdminNewsArticleDefaultPresenter: AdminNewsArticlePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let mediaAPI: MediaAdminAPIClient
    let renderingEngine: any RenderingEngine

    func renderList(
        model: AdminNewsArticleListModel,
        search: String,
        error: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "News articles",
            content: AdminNewsArticleListPage(
                model: model,
                search: search,
                error: error,
                permissions: context.currentUserAdminListActions,
                canAccess: context.isCurrentUserAllowed(
                    to: NewsPermissions.Articles.list
                )
            )
        )
    }

    func renderForm(
        input: AdminNewsArticleFormInput,
        categories: [AdminNewsArticleCategoryOption],
        error: String?,
        title: String,
        action: String,
        submitLabel: String,
        removeHref: String?
    ) async throws -> HTMLResponse {
        let selectedImageAsset = try? await mediaAPI.loadImageAsset(
            assetId: input.imageAssetId
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: title,
            content: AdminNewsArticleFormPage(
                input: input,
                selectedImageAsset: selectedImageAsset,
                categories: categories,
                error: error,
                title: title,
                action: action,
                submitLabel: submitLabel,
                removeHref: removeHref
            )
        )
    }

    func renderDetails(
        item: Components.Schemas.NewsArticleDetailSchema
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: item.title,
            content: AdminNewsArticleDetailsPage(
                item: item,
                permissions: context.currentUserAdminListActions
            )
        )
    }

    func renderError(
        _ message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "News article",
            content: NewsErrorPage(
                breadcrumb: NewsAdminRoutes.articlesBreadcrumb,
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
            try await renderingEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: NewAdminRemoveConfirmation.dialogTitle,
                content: NewAdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove news article",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.title],
                    action: NewsAdminRoutes.articleRemove(RouterPath(item.id))
                        .description + "/",
                    nonceToken: nonce,
                    hiddenFields: [.init(name: "id", value: item.id)]
                ),
                size: .small
            )
            .response(from: request, context: context)
    }

    func renderCreated() -> Response {
        AdminNotificationFlash.redirect(
            to: NewsAdminRoutes.articles.description + "/",
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
            to: NewsAdminRoutes.articleEdit(RouterPath(id)).description + "/",
            notification: .init(
                title: "Saved",
                message: "News article updated successfully."
            )
        )
    }

    func renderRemoved() -> Response {
        AdminNotificationFlash.redirect(
            to: NewsAdminRoutes.articles.description + "/",
            notification: .init(
                title: "Removed",
                message: "News article removed successfully."
            )
        )
    }
}
