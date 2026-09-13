import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import UserContracts

struct AdminEditUserRoleDefaultController: AdminEditUserRoleController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditUserRoleInteractor,
            presenter: any AdminEditUserRolePresenter
        )

    func getEditUserRole(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.update)
        else { return try await presenter.renderForbiddenPage() }
        let id = try context.requiredID()
        do {
            let role = try await interactor.load(id: id)
            return try await presenter.renderEditPage(
                id: id,
                state: .edit(name: role.name, notes: role.notes)
            )
        }
        catch let error as AdminEditUserRoleError {
            return try await presenter.renderEditError(
                id: id,
                input: nil,
                error: error
            )
        }
    }

    func postEditUserRole(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.update)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        var lastPayload: AdminEditUserRoleFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<AdminEditUserRoleFormInput>.self,
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
            try await interactor.edit(id: id, input: input)
            return presenter.renderSuccess(id: id)
        }
        catch let error as ValidationError {
            return
                try await presenter.renderValidationError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditUserRoleError {
            return
                try await presenter.renderEditError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
    }
}
