import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminRemoveAuthEmailDefaultPresenter:
    AdminRemoveAuthEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        item: NewAdminRemoveItemContext,
        identityId: String
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user emails",
            content: AuthEmailConfirmation(
                state: .init(
                    item: item,
                    identityId: identityId,
                    breadcrumb: AuthEmailRoutes.breadcrumb,
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user email",
            content: NewAdminStatusView(
                state: .init(
                    title: "Form expired",
                    message:
                        "This form is no longer valid. Please reload the page."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func renderError(
        item: NewAdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user email",
            content: AuthEmailError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthEmailRoutes.breadcrumb
                )
            )
        )
    }
}
