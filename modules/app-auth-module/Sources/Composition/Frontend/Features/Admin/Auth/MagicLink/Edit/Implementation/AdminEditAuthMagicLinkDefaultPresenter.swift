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

struct AdminEditAuthMagicLinkDefaultPresenter: AdminEditAuthMagicLinkPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func formState(
        credentialId: String = "",
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema] = [],
        isPersistent: Bool = false
    ) -> AuthMagicLinkForm.State {
        .init(
            credentialId: .init(
                key: "credential_id",
                label: "Auth email ID",
                value: credentialId,
                error: nil
            ),
            emailOptions: emails.map {
                .init(
                    label: $0.email,
                    value: $0.id,
                    isSelected: $0.id == credentialId
                )
            },
            isPersistent: .init(
                key: "is_persistent",
                label: "Persistent link",
                value: isPersistent,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var form = form
        form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit user magic link",
            content: AuthMagicLinkEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: form,
                    breadcrumb: AuthMagicLinkRoutes.breadcrumb
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
            title: "Edit user magic link",
            content: AuthMagicLinkError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthMagicLinkRoutes.breadcrumb
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
