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

struct AdminAddAuthEmailDefaultController: AdminAddAuthEmailController {

    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddAuthEmailInteractor,
            presenter: any AdminAddAuthEmailPresenter
        )

    func getAddAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.create)
        else { return try await presenter.renderForbiddenPage() }
        let identities = (try? await interactor.listIdentities()) ?? []
        return try await presenter.renderPage(
            form: presenter.formState(
                identityId: "",
                identities: identities
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.create)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        var lastPayload: AdminAddAuthEmailFormInput?
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminAddAuthEmailFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                var state = presenter.formState(
                    identityId: "",
                    identities: (try? await interactor.listIdentities()) ?? []
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
                    identityId: payload.normalizedIdentityId,
                    email: payload.normalizedEmail
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/emails/",
                notification: .init(
                    title: "Added",
                    message: "User email added successfully."
                )
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                identityId: lastPayload?.normalizedIdentityId ?? "",
                identities: (try? await interactor.listIdentities()) ?? []
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
                identityId: lastPayload?.normalizedIdentityId ?? ""
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
                identityId: lastPayload?.normalizedIdentityId ?? ""
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
        presenter: any AdminAddAuthEmailPresenter,
        state: AuthEmailForm.State
    ) async throws -> Response {
        try await presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
