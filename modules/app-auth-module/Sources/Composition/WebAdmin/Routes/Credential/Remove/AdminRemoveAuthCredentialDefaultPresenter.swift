import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminRemoveAuthCredentialDefaultPresenter:
    AdminRemoveAuthCredentialPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine
    let routes: Credential.Router.Routes

    func renderPage(
        item: AdminRemoveItemContext,
        model: AuthCredentialDetailsModel
    )
        async throws -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AuthCredentialConfirmation(
                state: .init(
                    item: item,
                    identityId: model.userId,
                    breadcrumb: routes.detailsBreadcrumb(model.userId),
                    nonceToken: nonceToken
                )
            ),
            size: .small
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove credential",
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

    func renderError(
        item: AdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove credential",
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: routes.removeBreadcrumb(item.id)
                )
            )
        )
    }

}
