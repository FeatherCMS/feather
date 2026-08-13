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
import WebStandards

struct AdminAddAuthMagicLinkDefaultController: AdminAddAuthMagicLinkController {

    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddAuthMagicLinkInteractor,
            presenter: any AdminAddAuthMagicLinkPresenter
        )

    func getAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(
                credentialId: "",
                isPersistent: false
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: AdminAddAuthMagicLinkFormInput?
        do {
            let payload = try await request.decode(
                as: AdminAddAuthMagicLinkFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    credentialId: payload.normalizedCredentialId,
                    isPersistent: payload.isPersistent.value
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/magic-links/",
                        title: "Added",
                        message: "User magic link added successfully."
                    )
                ]
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
            return try createResponse(
                request: request,
                context: context,
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
            return try createResponse(
                request: request,
                context: context,
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
            return try createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
    }

    private func createResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminAddAuthMagicLinkPresenter,
        state: AuthMagicLinkForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
