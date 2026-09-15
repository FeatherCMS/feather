import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormDefaultPresenter: AdminRemoveContactFormPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderConfirmation(id: String, name: String, permissions: Set<String>)
        async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form",
                    description: "This action cannot be undone."
                ),
                selectedItems: [name],
                action: ContactAdminRoutes.formRemove.description,
                cancel: ContactAdminRoutes.forms.description,
                submitLabel: "Remove form",
                hiddenFields: [.init(name: "selectedIds[]", value: id)]
            )
        )
    }

    func renderConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact forms",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact forms",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: ContactAdminRoutes.formRemove.description,
                cancel: ContactAdminRoutes.forms.description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }

}
