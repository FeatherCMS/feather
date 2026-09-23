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

struct AdminEditAuthMagicLinkDefaultController: AdminEditAuthMagicLinkController
{
    let buildRuntime: RuntimeBuilder<
        any AdminEditAuthMagicLinkInteractor,
        any AdminEditAuthMagicLinkPresenter
    >

    func getEditAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let id = try context.requiredID()
        let isEdited = request.hasQueryFlag("edited")
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserPermissions
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.update)
        else {
            return try await presenter.renderError(
                id: id,
                error: .forbidden,
                permissions: permissions
            )
        }
        do {
            let link = try await interactor.get(id: id)
            let emails = try await interactor.listEmails()
            return try await presenter.renderPage(
                id: id,
                isEdited: isEdited,
                form: presenter.formState(
                    credentialId: link.credentialId,
                    emails: emails,
                    isPersistent: link.isPersistent
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                id: id,
                error: error,
                permissions: permissions
            )
        }
    }

    func postEditAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.update)
        else {
            return
                try await presenter.renderError(
                    id: id,
                    error: .forbidden,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        var lastPayload: AdminEditAuthMagicLinkFormInput?
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminEditAuthMagicLinkFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                var state = presenter.formState(
                    credentialId: "",
                    isPersistent: false
                )
                state.error = "This form has expired. Please reload the page."
                return try await updateResponse(
                    request: request,
                    context: context,
                    id: id,
                    presenter: presenter,
                    state: state
                )
            }
            let payload = nonceRequest.input
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: id,
                    credentialId: payload.normalizedCredentialId,
                    isPersistent: payload.isPersistent.value
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/magic-links/\(id)/edit/",
                notification: .init(
                    title: "Saved",
                    message: "User magic link edited successfully."
                )
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.apply(errors: errs)
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = presenter.format(error: error)
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = error.displayMessage
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
    }

    private func updateResponse(
        request: Request,
        context: DefaultRequestContext,
        id: String,
        presenter: any AdminEditAuthMagicLinkPresenter,
        state: AuthMagicLinkForm.State
    ) async throws -> Response {
        try await presenter.renderPage(
            id: id,
            isEdited: false,
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
