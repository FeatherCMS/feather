import AuthAdminAPI
import AuthAppAPI
import AuthContracts
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

struct AdminAddAuthCredentialDefaultController: AdminAddAuthCredentialController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddAuthCredentialInteractor,
            any AdminAddAuthCredentialPresenter
        >

    func getAddCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.create)
        else { return try await presenter.renderForbiddenPage() }
        let emails = try await interactor.listEmails()
        return try await presenter.renderPage(
            form: presenter.formState(
                userId: "",
                emails: emails,
                email: "",
                password: ""
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.create)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        var payload: AdminAuthCredentialFormInput?
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminAuthCredentialFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                var state = presenter.formState(
                    userId: "",
                    emails: (try? await interactor.listEmails()) ?? [],
                    email: "",
                    password: ""
                )
                state.error = "This form has expired. Please reload the page."
                return
                    try await presenter.renderPage(
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            payload = nonceRequest.input
            try await payload!
                .validate(
                    requiredPassword: true,
                    validateUserId: false
                )
            try await interactor.execute(
                payload: .init(
                    userId: payload!.normalizedUserId,
                    email: payload!.normalizedEmail,
                    password: payload!.normalizedPassword
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/credentials/",
                notification: .init(
                    title: "Added",
                    message: "User credential added successfully."
                )
            )
        }
        catch let error as ValidationError {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.apply(
                errors: Dictionary(
                    uniqueKeysWithValues: error.failures.map {
                        ($0.key, $0.message)
                    }
                )
            )
            return
                try await presenter.renderPage(
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = presenter.format(error: error)
            return
                try await presenter.renderPage(
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = error.displayMessage
            return
                try await presenter.renderPage(
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
