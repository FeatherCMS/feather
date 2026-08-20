import UserContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird

struct AdminAddUserIdentityDefaultController: AdminAddUserIdentityController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddUserIdentityInteractor,
            presenter: any AdminAddUserIdentityPresenter
        )

    func getAddUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(status: "invited"),
            permissions: context.currentUserPermissions
        )
    }

    func postAddUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: AdminAddUserIdentityFormInput?

        do {
            let payload = try await request.decode(
                as: AdminAddUserIdentityFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()

            try await interactor.execute(
                entity: .init(
                    status: payload.status
                )
            )

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/identities/",
                        title: "Added",
                        message: "User identity added successfully."
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
                status: lastPayload?.status ?? "invited"
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
                status: lastPayload?.status ?? "invited"
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
                status: lastPayload?.status ?? "invited"
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
        presenter: any AdminAddUserIdentityPresenter,
        state: UserIdentityForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
