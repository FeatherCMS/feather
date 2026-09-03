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
import WebStandards

struct AdminGetMediaAssetDefaultPresenter: AdminGetMediaAssetPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetMediaAssetModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        let breadcrumb = mediaAssetsBreadcrumb(
            [
                .init(
                    label: "Details",
                    link: "/admin/media/assets/\(id)/"
                )
            ]
        )
        if let model {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Media asset details",
                description: "Media asset details",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: AssetDetailsView(
                    item: model.item,
                    variants: model.variants,
                    breadcrumb: breadcrumb,
                    canEdit: permissions.contains(
                        MediaPermissions.Assets.update.rawValue
                    ),
                    canRemove: permissions.contains(
                        MediaPermissions.Assets.delete.rawValue
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Media asset details",
            description: "Media asset details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaAssetErrorView(
                info: "Asset not found.",
                message: error ?? "Unknown error",
                breadcrumb: breadcrumb
            )
        )
    }

    private func mediaAssetsBreadcrumb(
        _ extra: [AdminBreadcrumb.State.Link] = []
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Assets", link: "/admin/media/assets/"),
            ] + extra
        )
    }
}
