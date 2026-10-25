import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule
import WebComponents

extension Variant.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variant.Router.Routes

        func renderEditPage(
            id: String,
            detail: Variant.Edit.Model,
            state: Variant.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            let variantNonce = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit media variant",
                content: Variant.Edit.Page(
                    id: id,
                    detail: detail,
                    form: Variant.Form(
                        state: state,
                        action: routes.editPath(id),
                        submitLabel: "Save changes",
                        nonceToken: variantNonce,
                        viewHref: nil,
                        removeHref: permissions.allows(
                            Variant.Permissions.delete
                        )
                            ? AdminLocation.remove(
                                path: routes.remove.path,
                                ids: [id],
                                returnTo:
                                    routes.editPath(id)
                            )
                            : nil
                    ),
                    routes: routes
                )
            )
        }

        func renderProcessorEditPage(
            variantId: String,
            processor: Variant.Processor.Edit.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            let processorNonce = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit media variant processor",
                content: Variant.Processor.Edit.Page(
                    variantId: variantId,
                    processor: processor,
                    form: Variant.Processor.Form(
                        processor: .init(
                            id: processor.id,
                            name: processor.name,
                            matchExtensions: processor.matchExtensions,
                            commandTemplate: processor.commandTemplate,
                            isActive: processor.isActive
                        ),
                        action:
                            routes.processorEditPath(
                                variantId,
                                processorId: processor.id
                            ),
                        nonceToken: processorNonce
                    ),
                    routes: routes
                )
            )
        }

        func renderErrorPage(error: Variant.Edit.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "Media variant not found",
                    message: "This variant may have been removed."
                )
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot edit media variants."
                )
            case .conflict:
                state = .init(
                    title: "Unable to save changes",
                    message: "A media variant with this key already exists."
                )
            case .unavailable:
                state = .init(
                    title: "Media variant unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit media variant",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton(
                        "Back",
                        href: routes.list.path,
                        style: .secondary
                    )
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
        }

        func renderSuccess(id: String) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "Media variant saved successfully."
                )
            )
        }

        private func status(for error: Variant.Edit.Error)
            -> HTTPResponse.Status
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
