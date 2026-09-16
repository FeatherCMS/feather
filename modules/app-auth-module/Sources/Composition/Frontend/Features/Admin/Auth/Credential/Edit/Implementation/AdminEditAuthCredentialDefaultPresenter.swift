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

struct AdminEditAuthCredentialDefaultPresenter: AdminEditAuthCredentialPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        id: String,
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var form = form
        form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit credential",
            content: AuthCredentialEdit(
                state: .init(
                    id: id,
                    form: form,
                    breadcrumb: AuthCredentialRoutes.breadcrumb
                )
            )
        )
    }

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit credential",
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthCredentialRoutes.breadcrumb
                )
            )
        )
    }

    func formState(
        userId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        email: String,
        password: String = ""
    )
        -> AuthCredentialForm.State
    {
        .init(
            identity: .init(
                key: "userId",
                label: "User identity",
                value: userId,
                error: nil
            ),
            identityOptions: emails.map {
                .init(
                    label: $0.email,
                    value: $0.email,
                    isSelected: $0.email == email
                )
            },
            email: .init(
                name: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            password: .init(
                name: "password",
                label: "New password",
                value: password,
                error: nil
            ),
            passwordRequired: false,
            error: nil,
            success: nil
        )
    }

    func format(error: OpenAPIRepositoryError) -> String {
        error.errorDescription
    }

}
