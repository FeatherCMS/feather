import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminGetUserHomeDefaultPresenter: AdminGetUserHomePresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetUserHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: "This is the admin home interface",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetUserHomeComponent()
        )
    }
}
