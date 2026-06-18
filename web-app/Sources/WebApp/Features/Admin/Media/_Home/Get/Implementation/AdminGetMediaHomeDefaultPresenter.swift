import HTML
import Hummingbird
import SGML

struct AdminGetMediaHomeDefaultPresenter: AdminGetMediaHomePresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetMediaHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: "Manage the media gallery, assets, and variants",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetMediaHomeComponent()
        )
    }
}
