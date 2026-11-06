import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML

extension Session.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Session.Router.Routes

        func renderPage(
            item: AdminRemoveItemContext,
            identityId: String
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: Session.Remove.Confirmation(
                    state: .init(
                        item: item,
                        identityId: identityId,
                        breadcrumb: routes.detailsBreadcrumb(
                            identityID: identityId
                        ),
                        nonceToken: nonceToken,
                        action: routes.removePath(
                            identityID: identityId,
                            sessionID: item.id
                        )
                    )
                ),
                size: .small
            )
        }

        func renderInvalidNoncePage() async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove session",
                content: AdminStatusView(
                    state: .init(
                        title: "Form expired",
                        message:
                            "This form is no longer valid. Please reload the page."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        func errorPage(
            item: AdminRemoveItemContext,
            identityId: String,
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove session",
                content: Session.Remove.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.detailsBreadcrumb(
                            identityID: identityId
                        )
                    )
                )
            )
        }

    }
}
