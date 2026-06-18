import Hummingbird

struct AdminRemoveMediaAssetDefaultPresenter: AdminRemoveMediaAssetPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminRemoveMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove media asset - Feather CMS",
            description: "Remove media asset - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AssetRemoveView(
                id: model.id,
                breadcrumb: breadcrumb(id: model.id)
            )
        )
    }

    private func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Assets", link: "/admin/media/assets/"),
                .init(
                    label: "Remove",
                    link: "/admin/media/assets/\(id)/remove/"
                ),
            ]
        )
    }
}
