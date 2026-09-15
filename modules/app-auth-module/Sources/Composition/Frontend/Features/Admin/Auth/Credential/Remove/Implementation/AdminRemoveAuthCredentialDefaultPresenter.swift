import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
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

struct AdminRemoveAuthCredentialDefaultPresenter:
    AdminRemoveAuthCredentialPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(item: NewAdminRemoveItemContext, model: AuthCredentialDetailsModel)
        async throws -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove credential",
            content: AuthCredentialConfirmation(
                state: .init(
                    item: item,
                    identityId: model.userId,
                    breadcrumb: AuthCredentialRoutes.detailsBreadcrumb(
                        RouterPath(model.userId)
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove credential",
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
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove credential",
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthCredentialRoutes.removeBreadcrumb(
                        RouterPath(item.id)
                    )
                )
            )
        )
    }

}
