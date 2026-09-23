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

struct AdminEditAuthCredentialDefaultController:
    AdminEditAuthCredentialController
{
    let buildRuntime: RuntimeBuilder<
        any AdminEditAuthCredentialInteractor,
        any AdminEditAuthCredentialPresenter
    >

    func getEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.update)
        else {
            return try await presenter.renderError(
                id: id,
                error: .forbidden,
                permissions: context.currentUserPermissions
            )
        }
        do {
            let credential = try await interactor.get(id: id)
            let emails = try await interactor.listEmails()
            return try await presenter.renderPage(
                id: id,
                form: presenter.formState(
                    userId: credential.userId,
                    emails: emails,
                    email: credential.email,
                    password: ""
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.update)
        else {
            return
                try await presenter.renderError(
                    id: id,
                    error: .forbidden,
                    permissions: context.currentUserPermissions
                )
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
                        id: id,
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            payload = nonceRequest.input
            try await payload!.validate(requiredPassword: false)
            try await interactor.execute(
                id: id,
                payload: .init(
                    userId: payload!.normalizedUserId,
                    email: payload!.normalizedEmail,
                    password: payload!.normalizedPassword
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/credentials/\(id)/edit/",
                notification: .init(
                    title: "Saved",
                    message: "User credential edited successfully."
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
                    id: id,
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
                    id: id,
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
                    id: id,
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
