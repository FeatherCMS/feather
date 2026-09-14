import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormSubmissionsDefaultPresenter:
    AdminRemoveContactFormSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderConfirmation(
        formId: String,
        item: AdminContactFormSubmissionItem,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Remove contact form submission",
            permissions: permissions,
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(title: "Remove contact form submission", description: "This action cannot be undone."),
                selectedItems: [item.createdAt],
                action: ContactAdminRoutes.formSubmissionRemove(formID: RouterPath(formId), submissionID: RouterPath(item.id)).description,
                cancel: ContactAdminRoutes.formSubmissions(RouterPath(formId)).description,
                submitLabel: "Remove submission"
            )
        )
    }

    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Remove contact form submissions",
            permissions: permissions,
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(title: "Remove contact form submissions", description: "This action cannot be undone."),
                selectedItems: selectedIds,
                action: ContactAdminRoutes.formSubmissionRemove(RouterPath(formId)).description,
                cancel: ContactAdminRoutes.formSubmissions(RouterPath(formId)).description,
                hiddenFields: selectedIds.map { .init(name: "selectedIds[]", value: $0) }
            )
        )
    }

}
