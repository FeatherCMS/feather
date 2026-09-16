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

struct AdminAddAuthMagicLinkDefaultPresenter: AdminAddAuthMagicLinkPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
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
            title: "Add user magic link",
            content: AuthMagicLinkAdd(
                state: .init(
                    form: form,
                    breadcrumb: AuthMagicLinkRoutes.breadcrumb
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add magic link",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot add magic links."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func formState(
        credentialId: String = "",
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema] = [],
        isPersistent: Bool = false
    ) -> AuthMagicLinkForm.State {
        .init(
            credentialId: .init(
                key: "credential_id",
                label: "Auth email",
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

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
