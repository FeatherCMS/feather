import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetDefaultPresenter: AdminListMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListMediaAssetModel,
        search: String?,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        let content = AssetListView(
            state: .init(
                entries: model.entries,
                pageState: model.pageState,
                search: search ?? "",
                parentId: model.parentId,
                currentFolder: model.currentFolder,
                ancestors: model.ancestors,
                view: model.view,
                picker: model.picker,
                permissions: permissions
            )
        )
        if model.picker.isEnabled {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Select media asset",
                content: content
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media assets",
            content: content
        )
    }

    func renderErrorPage(
        message: String,
        picker: Bool
    ) async throws -> HTMLResponse {
        if picker {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Select media asset",
                content: MediaAssetErrorView(
                    info: "Unable to load media assets.",
                    message: message
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media assets",
            content: MediaAssetErrorView(
                info: "Unable to load media assets.",
                message: message
            )
        )
    }

    func renderRemovePage(
        pageState: NewAdminListPageState,
        search: String?,
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: MediaAssetRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected assets",
            content: NewAdminRemoveConfirmation(
                breadcrumb: MediaAssetRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected assets",
                    description: "Confirm removal of the selected media assets."
                ),
                selectedItems: items.map(\.label),
                action: MediaAssetRoutes.remove.description,
                cancel: cancel,
                submitLabel: "Remove selected",
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                } + [
                    .init(name: "page", value: String(pageState.page)),
                    .init(name: "search", value: search ?? ""),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse {
        let page = try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media assets",
            content: NewAdminStatusView(
                state: .init(
                    title: "Confirmation expired",
                    message:
                        "This confirmation is no longer valid. Please try again."
                ),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: .badRequest)
    }
}
