import Hummingbird

struct AdminEditMediaAssetDefaultPresenter: AdminEditMediaAssetPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderEditPage(
        model: AdminEditMediaAssetModel,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit media asset - Feather CMS",
            description: "Edit media asset - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AssetEditView(
                state: .init(
                    model: model,
                    isEdited: isEdited,
                    canAccess: permissions.contains(
                        AdminMedia.Scope.assets.permission(for: .update)
                    ),
                    breadcrumb: breadcrumb(for: model.id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit media asset - Feather CMS",
            description: "Edit media asset - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaAssetErrorView(
                info: info,
                message: message,
                breadcrumb: breadcrumb(for: id)
            )
        )
    }

    private func breadcrumb(
        for id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Assets", link: "/admin/media/assets/"),
                .init(label: "Edit", link: "/admin/media/assets/\(id)/edit/"),
            ]
        )
    }
}
