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
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetRedirectHomeComponent()
        )
    }
}
