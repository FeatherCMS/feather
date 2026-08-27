import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML

struct AdminGetWebHomeDefaultPresenter: AdminGetWebHomePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderHome(
        model: AdminGetWebHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: "This is the admin home interface",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetWebHomeComponent()
        )
    }
}
