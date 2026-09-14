import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactSubmissionsDefaultPresenter:
    AdminRemoveContactSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderConfirmation(selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
    {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Remove contact submissions",
            permissions: permissions,
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact submissions",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: ContactAdminRoutes.submissionRemove.description,
                cancel: ContactAdminRoutes.submissions.description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }
}
