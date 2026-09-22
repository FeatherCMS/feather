import FeatherAdmin
import Hummingbird

struct AdminRemoveContactFormSubmissionsDefaultPresenter:
    AdminRemoveContactFormSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        formId: String,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        guard items.count == 1, let item = items.first else {
            return try await renderBulkRemovePage(formId: formId, items: items)
        }
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form submission",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form submission",
                    description: "This action cannot be undone."
                ),
                selectedItems: [item.label],
                action:
                    ContactAdminRoutes.formSubmissionRemove(
                        formID: RouterPath(formId),
                        submissionID: RouterPath(item.id)
                    )
                    .description,
                cancel: ContactAdminRoutes.formSubmissions(RouterPath(formId))
                    .description,
                submitLabel: "Remove submission",
                nonceToken: nonceToken
            )
        )
    }

    private func renderBulkRemovePage(
        formId: String,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form submissions",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form submissions",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action:
                    ContactAdminRoutes.formSubmissionRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formSubmissions(RouterPath(formId))
                    .description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }

}
