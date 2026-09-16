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

struct AdminAddAuthEmailDefaultPresenter: AdminAddAuthEmailPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
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
            title: "Add user email",
            content: AuthEmailAdd(
                state: .init(
                    form: form,
                    breadcrumb: AuthEmailRoutes.breadcrumb
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add email",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot add user emails."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func formState(
        identityId: String = "",
        identities: [AuthCredentialIdentityOption] = []
    ) -> AuthEmailForm.State {
        .init(
            identityId: .init(
                key: "identity_id",
                label: "User identity",
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
