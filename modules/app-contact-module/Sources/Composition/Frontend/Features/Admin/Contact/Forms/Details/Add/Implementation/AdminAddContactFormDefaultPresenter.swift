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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form",
            content: ContactFormAddPage(
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
                    breadcrumb: ContactAdminRoutes.formsBreadcrumb
                )
            )
        )
    }
}
