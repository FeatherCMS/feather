import FeatherValidation
import HTML
import Hummingbird

struct AdminAddUserAccountDefaultController: AdminAddUserAccountController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddUserAccountInteractor,
            presenter: any AdminAddUserAccountPresenter
        )

    func getAddUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(email: ""),
            permissions: context.currentUserPermissions
        )
    }

    func postAddUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: AdminAddUserAccountFormInput?

        do {
            let payload = try await request.decode(
                as: AdminAddUserAccountFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()

            try await interactor.execute(
                entity: .init(
                    email: payload.normalizedEmail,
                    password: payload.password
                )
            )

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/accounts/",
                        title: "Added",
                        message: "User account added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.apply(errors: errors)
            return try createFormResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.error = presenter.format(error: error)
            return try createFormResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? ""
            )
            state.error = error.displayMessage
            return try createFormResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
    }

    private func createFormResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminAddUserAccountPresenter,
        state: UserAccountForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
