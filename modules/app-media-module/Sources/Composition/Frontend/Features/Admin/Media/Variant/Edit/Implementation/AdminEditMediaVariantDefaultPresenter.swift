import FeatherAdmin
import Hummingbird
import MediaAdminAPI
import MediaContracts
import WebComponents

struct AdminEditMediaVariantDefaultPresenter: AdminEditMediaVariantPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(id: String, detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema, state: MediaVariantFormView.State, permissions: NewAdminListActions) async throws -> HTMLResponse {
        let variantNonce = await AdminNonceStore.shared.issue(sessionToken: context.sessionToken)
        let addProcessorNonce = await AdminNonceStore.shared.issue(sessionToken: context.sessionToken)
        var processorTokens: [String: MediaVariantProcessorFormTokens] = [:]
        for processor in detail.processors {
            processorTokens[processor.id] = .init(
                edit: await AdminNonceStore.shared.issue(sessionToken: context.sessionToken),
                remove: await AdminNonceStore.shared.issue(sessionToken: context.sessionToken)
            )
        }
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit media variant",
            content: MediaVariantEditPage(
                id: id,
                detail: detail,
                form: MediaVariantFormView(
                    state: state,
                    action: MediaVariantRoutes.edit(RouterPath(id)).description,
                    submitLabel: "Save changes",
                    nonceToken: variantNonce,
                    viewHref: nil,
                    removeHref: permissions.allows(MediaPermissions.Variants.delete)
                        ? NewAdminLocation.remove(path: MediaVariantRoutes.remove.description, ids: [id], returnTo: MediaVariantRoutes.edit(RouterPath(id)).description)
                        : nil
                ),
                processorTokens: processorTokens,
                addProcessorNonce: addProcessorNonce,
                permissions: permissions
            )
        )
    }

    func renderErrorPage(error: AdminEditMediaVariantError) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound: state = .init(title: "Media variant not found", message: "This variant may have been removed.")
        case .unauthorized: state = .init(title: "Session expired", message: "Please sign in again.")
        case .forbidden: state = .init(title: "Forbidden", message: "Your account cannot edit media variants.")
        case .conflict: state = .init(title: "Unable to save changes", message: "A media variant with this key already exists.")
        case .unavailable: state = .init(title: "Media variant unavailable", message: "The request could not be completed. Please try again.")
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit media variant",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: MediaVariantRoutes.list.description, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    func renderSuccess(id: String) -> Response {
        AdminNotificationFlash.redirect(to: MediaVariantRoutes.edit(RouterPath(id)).description, notification: .init(title: "Saved", message: "Media variant saved successfully."))
    }

    private func status(for error: AdminEditMediaVariantError) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .unavailable: .serviceUnavailable
        }
    }
}
