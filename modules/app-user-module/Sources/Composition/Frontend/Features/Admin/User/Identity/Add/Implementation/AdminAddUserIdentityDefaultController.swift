import FeatherAdmin
import FeatherValidation
import Hummingbird
import UserContracts

struct AdminAddUserIdentityDefaultController: AdminAddUserIdentityController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminAddUserIdentityInteractor,
            any AdminAddUserIdentityPresenter
        >

    func getAddUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.create)
        else {
            return try await presenter.renderForbiddenPage()
        }
        let roleOptions = (try? await interactor.loadRoleOptions()) ?? []
        return try await presenter.renderAddPage(
            state: .empty(roleOptions: roleOptions)
        )
    }

    func postAddUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.create)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        let roleOptions = (try? await interactor.loadRoleOptions()) ?? []
        var lastPayload: AdminAddUserIdentityFormInput?

        do {
            let payload = try await request.decode(
                as: NonceRequest<AdminAddUserIdentityFormInput>.self,
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
                return try await presenter.renderInvalidNoncePage()
                    .response(from: request, context: context)
            }
            try await input.validate()

            try await interactor.add(input: input)
            return presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return
                try await presenter.renderValidationError(
                    input: lastPayload,
                    error: error,
                    roleOptions: roleOptions
                )
                .response(from: request, context: context)
        }
        catch let error as AdminAddUserIdentityError {
            return
                try await presenter.renderAddError(
                    input: lastPayload,
                    error: error,
                    roleOptions: roleOptions
                )
                .response(from: request, context: context)
        }
    }
}
