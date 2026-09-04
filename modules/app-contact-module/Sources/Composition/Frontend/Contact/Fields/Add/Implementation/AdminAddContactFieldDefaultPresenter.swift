import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFieldDefaultPresenter:
    AdminAddContactFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(
                label: "Add field",
                link: "/admin/contact/fields/add/"
            ),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add contact form field",
            description: "Add contact form field",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFieldAddView(
                state: .init(
                    key: model.key,
                    type: model.type,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired,
                    position: model.position,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
