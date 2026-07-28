import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetContactFormDefaultPresenter: AdminGetContactFormPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form - Feather CMS",
            description: "View contact form",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormEdit(
                state: .init(
                    id: item.id,
                    isEdited: false,
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
                            label: "Details",
                            link: "/admin/contact/forms/\(item.id)/details/"
                        ),
                    ])
                )
            )
        )
    }
}
