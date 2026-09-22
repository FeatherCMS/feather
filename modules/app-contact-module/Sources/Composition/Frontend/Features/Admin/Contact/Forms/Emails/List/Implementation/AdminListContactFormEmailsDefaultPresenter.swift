import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormEmailsDefaultPresenter:
    AdminListContactFormEmailsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form emails",
            content: ContactFormEmailsTable(
                state: .init(
                    id: item.key,
                    mails: item.mails,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: ContactAdminRoutes.formEmailsBreadcrumb(
                        RouterPath(item.key)
                    ),
                    error: error
                )
            )
        )
    }

}
