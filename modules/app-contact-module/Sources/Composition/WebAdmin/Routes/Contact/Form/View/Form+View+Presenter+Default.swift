import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird

extension ContactModule.Form.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderDetailsPage(
            item: ContactModule.Form.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact form",
                content: ContactModule.Form.View.Page(
                    item: item,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: routes.formDetailsBreadcrumb(item.key),
                    routes: routes,
                    error: error
                )
            )
        }
    }
}
