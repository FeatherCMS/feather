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

struct AdminAddAuthMagicLinkDefaultController: AdminAddAuthMagicLinkController {

    let buildRuntime: RuntimeBuilder<
        any AdminAddAuthMagicLinkInteractor,
        any AdminAddAuthMagicLinkPresenter
    >

    func getAddAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.create)
        else { return try await presenter.renderForbiddenPage() }
        let emails = try await interactor.listEmails()
        return try await presenter.renderPage(
            form: presenter.formState(
                credentialId: "",
                emails: emails,
                isPersistent: false
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.create)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        var lastPayload: AdminAddAuthMagicLinkFormInput?
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminAddAuthMagicLinkFormInput>.self,
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
                    emails: (try? await interactor.listEmails()) ?? [],
                    isPersistent: false
                )
                state.error = "This form has expired. Please reload the page."
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    state: state
                )
            }
            let payload = nonceRequest.input
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    credentialId: payload.normalizedCredentialId,
                    isPersistent: payload.isPersistent.value
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/magic-links/",
                notification: .init(
                    title: "Added",
                    message: "User magic link added successfully."
                )
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.apply(errors: errs)
            return try await createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = presenter.format(error: error)
            return try await createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                credentialId: lastPayload?.normalizedCredentialId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = error.displayMessage
            return try await createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
    }

    private func createResponse(
        request: Request,
        context: DefaultRequestContext,
        presenter: any AdminAddAuthMagicLinkPresenter,
        state: AuthMagicLinkForm.State
    ) async throws -> Response {
        try await presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
