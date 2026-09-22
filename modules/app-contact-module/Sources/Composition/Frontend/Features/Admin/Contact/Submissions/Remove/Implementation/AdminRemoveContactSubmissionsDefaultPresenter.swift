import FeatherAdmin
import Hummingbird

struct AdminRemoveContactSubmissionsDefaultPresenter:
    AdminRemoveContactSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws
        -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact submissions",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact submissions",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: ContactAdminRoutes.submissionRemove.description,
                cancel: ContactAdminRoutes.submissions.description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }
}
