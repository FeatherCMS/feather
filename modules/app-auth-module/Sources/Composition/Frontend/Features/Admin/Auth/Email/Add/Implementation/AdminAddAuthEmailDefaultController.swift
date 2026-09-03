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
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(
                identityId: "",
                isPrimary: false
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: AdminAddAuthEmailFormInput?
        do {
            let payload = try await request.decode(
                as: AdminAddAuthEmailFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    identityId: payload.normalizedIdentityId,
                    email: payload.normalizedEmail,
                    isPrimary: payload.isPrimary.value
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/emails/",
                        title: "Added",
                        message: "User email added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                identityId: lastPayload?.normalizedIdentityId ?? "",
                isPrimary: lastPayload?.isPrimary.value ?? false
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
                identityId: lastPayload?.normalizedIdentityId ?? "",
                isPrimary: lastPayload?.isPrimary.value ?? false
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
                identityId: lastPayload?.normalizedIdentityId ?? "",
                isPrimary: lastPayload?.isPrimary.value ?? false
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
        context: DefaultRequestContext,
        presenter: any AdminAddAuthEmailPresenter,
        state: AuthEmailForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
