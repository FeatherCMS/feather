import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormDefaultPresenter: AdminAddContactFormPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add contact form",
            description: "Add contact form",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormAdd(
                state: .init(
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
                        .init(label: "Add", link: "/admin/contact/forms/add/"),
                    ])
                )
            )
        )
    }
}
