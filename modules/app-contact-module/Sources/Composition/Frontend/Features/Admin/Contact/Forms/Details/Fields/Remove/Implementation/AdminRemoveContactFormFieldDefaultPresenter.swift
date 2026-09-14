import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormFieldDefaultPresenter:
    AdminRemoveContactFormFieldPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderConfirmation(
        formId: String,
        fieldId: String,
        label: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form field",
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form field",
                    description: "This action cannot be undone."
                ),
                selectedItems: [label],
                action:
                    ContactAdminRoutes.formFieldRemove(
                        formID: RouterPath(formId),
                        fieldID: RouterPath(fieldId)
                    )
                    .description,
                cancel: ContactAdminRoutes.formFields(RouterPath(formId))
                    .description,
                submitLabel: "Remove field"
            )
        )
    }
    func renderConfirmation(
        formId: String,
        selectedIds: [String]
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form fields",
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form fields",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: ContactAdminRoutes.formFieldRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formFields(RouterPath(formId))
                    .description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }
}
