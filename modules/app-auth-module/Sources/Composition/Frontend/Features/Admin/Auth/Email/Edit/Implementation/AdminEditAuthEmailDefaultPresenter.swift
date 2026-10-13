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

struct AdminEditAuthEmailDefaultPresenter: AdminEditAuthEmailPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func formState(
        identityId: String = "",
        identities: [AuthCredentialIdentityOption] = [],
        email: String = ""
    ) -> AuthEmailForm.State {
        .init(
            identityId: .init(
                key: "identity_id",
                label: "Auth email ID",
                value: identityId,
                error: nil
            ),
            identityOptions: identities.map {
                .init(
                    label: $0.label,
                    value: $0.id,
                    isSelected: $0.id == identityId
                )
            },
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var form = form
        form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit user email",
            content: AuthEmailEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: form,
                    breadcrumb: AuthEmailRoutes.breadcrumb
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
            title: "Edit user email",
            content: AuthEmailError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthEmailRoutes.breadcrumb
                )
            )
        )
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
