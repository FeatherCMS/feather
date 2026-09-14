import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
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
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListMediaAssetModel,
        search: String?,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
        let content = AssetListView(
            state: .init(
                folders: model.folders,
                items: model.items,
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
            return renderEngine.renderPage(
                request: request,
                title: "Select media asset",
                description: "Select media asset",
                imagePath: "images/logos/logo.png",
                content: Div {
                    renderContext.render(content)
                }
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
        var renderContext = RenderContext()
        if picker {
            return renderEngine.renderPage(
                request: request,
                title: "Select media asset",
                description: "Select media asset",
                imagePath: "images/logos/logo.png",
                content: Div {
                    renderContext.render(
                        MediaAssetErrorView(
                            info: "Unable to load media assets.",
                            message: message
                        )
                    )
                }
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

    func renderRemoveConfirmation(
        pageState: NewAdminListPageState,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        selectedIds: [String]
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected assets",
            content: NewAdminConfirmation(
                breadcrumb: MediaAssetRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected assets",
                    description: "Confirm removal of the selected media assets."
                ),
                selectedItems: selectedIds,
                action: MediaAssetRoutes.remove.description,
                cancel: mediaAssetsPath(
                    pageState: pageState,
                    search: search,
                    parentId: parentId,
                    view: view
                ),
                submitLabel: "Remove selected"
            )
        )
    }

    private func mediaAssetsPath(
        pageState: NewAdminListPageState,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode
    ) -> String {
        var items: [String] = []
        if pageState.page > 1 {
            items.append("page=\(pageState.page)")
        }
        if let search, !search.isEmpty {
            items.append("search=\(search.queryEncoded())")
        }
        if let parentId, !parentId.isEmpty {
            items.append("parent_id=\(parentId.queryEncoded())")
        }
        if view != .grid {
            items.append("view=\(view.rawValue)")
        }
        let path = MediaAssetRoutes.list.description
        return items.isEmpty
            ? path
            : "\(path)?\(items.joined(separator: "&"))"
    }
}
