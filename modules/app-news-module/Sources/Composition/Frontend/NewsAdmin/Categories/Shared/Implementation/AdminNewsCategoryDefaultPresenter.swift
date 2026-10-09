import FeatherAdmin
import FeatherContracts
import Hummingbird
import MediaFrontend
import NewsAdminAPI
import NewsContracts

struct AdminNewsCategoryDefaultPresenter: AdminNewsCategoryPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let mediaAPI: MediaAdminAPIClient
    let renderingEngine: any RenderingEngine

    func renderList(
        model: AdminNewsCategoryListModel,
        search: String,
        error: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "News categories",
            content: AdminNewsCategoryListPage(
                model: model,
                search: search,
                error: error,
                permissions: context.currentUserAdminListActions,
                canAccess: context.isCurrentUserAllowed(
                    to: NewsPermissions.Categories.list
                )
            )
        )
    }

    func renderForm(
        input: AdminNewsCategoryFormInput,
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
            content: AdminNewsCategoryFormPage(
                input: input,
                selectedImageAsset: selectedImageAsset,
                error: error,
                title: title,
                action: action,
                submitLabel: submitLabel,
                removeHref: removeHref
            )
        )
    }

    func renderDetails(
        item: Components.Schemas.NewsCategoryDetailSchema
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: item.title,
            content: AdminNewsCategoryDetailsPage(
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
            title: "News category",
            content: NewsErrorPage(
                breadcrumb: NewsAdminRoutes.categoriesBreadcrumb,
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
            try await renderingEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: NewAdminRemoveConfirmation.dialogTitle,
                content: NewAdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove news category",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.title],
                    action: NewsAdminRoutes.categoryRemove(RouterPath(item.id))
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
            to: NewsAdminRoutes.categories.description + "/",
            notification: .init(
                title: "Added",
                message: "News category added successfully."
            )
        )
    }

    func renderUpdated(
        id: String
    ) -> Response {
        AdminNotificationFlash.redirect(
            to: NewsAdminRoutes.categoryEdit(RouterPath(id)).description + "/",
            notification: .init(
                title: "Saved",
                message: "News category updated successfully."
            )
        )
    }

    func renderRemoved() -> Response {
        AdminNotificationFlash.redirect(
            to: NewsAdminRoutes.categories.description + "/",
            notification: .init(
                title: "Removed",
                message: "News category removed successfully."
            )
        )
    }
}
