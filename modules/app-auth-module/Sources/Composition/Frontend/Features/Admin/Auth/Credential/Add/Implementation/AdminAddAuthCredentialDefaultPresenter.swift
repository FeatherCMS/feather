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

struct AdminAddAuthCredentialDefaultPresenter: AdminAddAuthCredentialPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
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
            title: "Add credential",
            content: AuthCredentialAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add credential",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot add user credentials."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func formState(
        userId: String = "",
        emails: [AuthCredentialIdentityOption] = [],
        email: String = "",
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
                    label: $0.label,
                    value: $0.id,
                    isSelected: $0.id == email
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
                label: "Password",
                value: password,
                error: nil
            ),
            passwordRequired: true,
            error: nil,
            success: nil
        )
    }

    func format(error: OpenAPIRepositoryError) -> String {
        error.errorDescription
    }

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Credentials", link: "/admin/auth/credentials/"),
        ]
    }
}
