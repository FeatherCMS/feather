import HTML
import Hummingbird

struct AdminAddMediaAssetDefaultPresenter: AdminAddMediaAssetPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let content = AssetAddView(
            state: .init(
                form: .init(
                    parentId: model.parentId,
                    fileName: model.fileName,
                    type: model.type,
                    title: model.title,
                    altText: model.altText,
                    data: model.data,
                    error: model.error,
                    view: model.view,
                    action: model.action,
                    isPicker: model.isPicker,
                    selectedAsset: model.selectedAsset
                ),
                breadcrumb: breadcrumb()
            )
        )
        if model.isPicker {
            return renderEngine.renderPage(
                request: request,
                title: "Upload media asset",
                description: "Upload media asset",
                imagePath: "images/puppy.png",
                content: Div {
                    content
                }
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add media asset - Feather CMS",
            description: "Add media asset - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: content
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Assets", link: "/admin/media/assets/"),
                .init(label: "Add", link: "/admin/media/assets/add/"),
            ]
        )
    }
}
