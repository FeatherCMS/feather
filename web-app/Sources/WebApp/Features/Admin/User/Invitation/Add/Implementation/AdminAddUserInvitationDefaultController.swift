import FeatherValidation
import HTML
import Hummingbird

struct AdminAddUserInvitationDefaultController: AdminAddUserInvitationController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddUserInvitationInteractor,
            presenter: any AdminAddUserInvitationPresenter
        )

    func getAddUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(email: ""),
            permissions: context.currentUserPermissions
        )
    }

    func postAddUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        var lastPayload: AdminAddUserInvitationFormInput?
        do {
            let payload = try await request.decode(
                as: AdminAddUserInvitationFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            let (interactor, _) = runtime
            try await interactor.execute(
                entity: .init(email: payload.normalizedEmail)
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/invitations/",
                        title: "Added",
                        message: "User invitation added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = runtime.presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.apply(errors: errs)
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = runtime.presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.error = runtime.presenter.format(error: error)
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
        catch {
            var state = runtime.presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.error = error.displayMessage
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
    }

    private func createResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminAddUserInvitationPresenter,
        state: UserInvitationForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
