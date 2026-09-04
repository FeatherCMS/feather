import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormDefaultPresenter: AdminEditContactFormPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit contact form",
            description: "Edit contact form",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormEdit(
                state: .init(
                    id: item.id,
                    isEdited: request.hasQueryFlag("edited"),
                    form: .init(
                        name: item.name,
                        successMessage: item.successMessage,
                        failureMessage: item.failureMessage,
                        redirectUrl: item.redirectUrl,
                        fieldIDs: item.selectedFieldIDs,
                        availableFields: item.availableFields,
                        mails: item.mails,
                        error: error,
                        success: nil
                    ),
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(label: "Forms", link: "/admin/contact/forms/"),
                        .init(
                            label: "Edit",
                            link: "/admin/contact/forms/\(item.id)/edit/"
                        ),
                    ])
                )
            )
        )
    }
}
