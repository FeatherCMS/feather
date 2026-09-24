import FeatherAdmin
import HTML
import Hummingbird
import UserContracts

struct AdminViewUserIdentityDefaultController: AdminViewUserIdentityController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewUserIdentityInteractor,
            any AdminViewUserIdentityPresenter
        >

    func getUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Identities.read)
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        let id = try request.requiredID()
        do {
            let identity = try await interactor.load(id: id)
            let roleNames = try await interactor.roleNames(
                for: identity.roleIds
            )
            let model = AdminViewUserIdentityModel(
                details: .init(
                    id: identity.id,
                    name: identity.name,
                    status: identity.status,
                    roleIds: identity.roleIds
                ),
                roleNames: roleNames
            )
            return try await presenter.renderDetailsPage(
                model: model,
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as AdminViewUserIdentityError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

}
