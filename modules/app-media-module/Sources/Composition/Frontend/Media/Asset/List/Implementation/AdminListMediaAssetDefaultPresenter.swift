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
import WebComponents
import WebBuilders

struct AdminListMediaAssetDefaultPresenter: AdminListMediaAssetPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListMediaAssetModel,
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        isAdded: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            MediaPermissions.Assets.list.rawValue
        )
        let content = AssetListView(
            state: .init(
                folders: model.folders,
                items: model.items,
                page: model.page,
                pageSize: model.pageSize,
                total: model.total,
                search: search ?? "",
                parentId: parentId,
                currentFolder: model.currentFolder,
                ancestors: model.ancestors,
                view: view,
                picker: model.picker,
                isAdded: isAdded,
                isRemoved: isRemoved,
                canAccess: canAccess,
                permissions: permissions,
                canAdd: permissions.contains(
                    MediaPermissions.Assets.create.rawValue
                ),
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your account cannot access media assets.",
                breadcrumb: mediaAssetsBreadcrumb()
            )
        )
        if let error {
            if model.picker.isEnabled {
                return renderEngine.renderPage(
                    request: request,
                    title: "Select media asset",
                    description: "Select media asset",
                    imagePath: "images/logos/logo.png",
                    content: Div {
                        MediaAssetErrorView(
                            info: "Unable to load media assets.",
                            message: error,
                            breadcrumb: mediaAssetsBreadcrumb()
                        ).html()
                    }
                )
            }
            return renderEngine.renderAdminPage(
                request: request,
                title: "Media assets",
                description: "Media assets",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: MediaAssetErrorView(
                    info: "Unable to load media assets.",
                    message: error,
                    breadcrumb: mediaAssetsBreadcrumb()
                )
            )
        }
        if model.picker.isEnabled {
            return renderEngine.renderPage(
                request: request,
                title: "Select media asset",
                description: "Select media asset",
                imagePath: "images/logos/logo.png",
                content: Div {
                    content.html()
                }
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Media assets",
            description: "Media assets",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: content
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected assets",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: mediaAssetsBreadcrumb(),
                    title: "Remove selected assets",
                    message:
                        "Are you sure you want to remove these selected assets? This action cannot be undone.",
                    action: "/admin/media/assets/remove/",
                    cancelLink: mediaAssetsPath(
                        page: page,
                        search: search,
                        parentId: parentId,
                        view: view
                    ),
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func mediaAssetsBreadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Media", link: "/admin/media/"),
            .init(label: "Assets", link: "/admin/media/assets/"),
        ])
    }

    private func mediaAssetsPath(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode
    ) -> String {
        var items: [String] = []
        if page > 1 {
            items.append("page=\(page)")
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
        return items.isEmpty
            ? "/admin/media/assets/"
            : "/admin/media/assets/?\(items.joined(separator: "&"))"
    }
}
