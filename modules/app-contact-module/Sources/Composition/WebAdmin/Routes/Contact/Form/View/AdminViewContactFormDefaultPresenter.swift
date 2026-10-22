import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactFormDefaultPresenter: AdminViewContactFormPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Contact form",
            content: ContactFormDetailsView(
                item: item,
                permissions: .init(Set(permissions.map(PermissionKey.init))),
                breadcrumb: ContactAdminRoutes.formsBreadcrumb,
                error: error
            )
        )
    }
}
