import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactFormDefaultPresenter: AdminViewContactFormPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Contact form",
            permissions: permissions,
            content: ContactFormDetailsView(
                item: item,
                permissions: .init(Set(permissions.map(PermissionKey.init))),
                breadcrumb: ContactAdminRoutes.formsBreadcrumb,
                error: error
            )
        )
    }
}
