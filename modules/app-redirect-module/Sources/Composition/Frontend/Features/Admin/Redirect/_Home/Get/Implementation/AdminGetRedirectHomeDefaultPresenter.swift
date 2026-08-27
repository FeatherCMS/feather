import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import SGML

struct AdminGetRedirectHomeDefaultPresenter: AdminGetRedirectHomePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderHome(
        model: AdminGetRedirectHomeModel,
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
            content: AdminGetRedirectHomeComponent()
        )
    }
}
