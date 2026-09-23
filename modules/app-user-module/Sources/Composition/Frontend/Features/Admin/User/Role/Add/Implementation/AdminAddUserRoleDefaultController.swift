import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import UserContracts

struct AdminAddUserRoleDefaultController: AdminAddUserRoleController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddUserRoleInteractor,
            any AdminAddUserRolePresenter
        >

    func getAddUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.create)
        else {
            return try await presenter.renderForbiddenPage()
        }
        return try await presenter.renderAddPage(state: .addEmpty())
    }

    func postAddUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.create)
        else {
            return try await runtime.presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        var lastPayload: AdminAddUserRoleFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<AdminAddUserRoleFormInput>.self,
                context: context
            )
            let input = payload.input
            lastPayload = input
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return try await runtime.presenter
                    .renderInvalidNoncePage()
                    .response(from: request, context: context)
            }
            try await input.validate()
            try await runtime.interactor.add(input: input)
            return runtime.presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return try await runtime.presenter
                .renderValidationError(input: lastPayload, error: error)
                .response(from: request, context: context)
        }
        catch let error as AdminAddUserRoleError {
            return try await runtime.presenter
                .renderAddError(input: lastPayload, error: error)
                .response(from: request, context: context)
        }
    }
}
