import FeatherAdmin
import HTML
import Hummingbird
import UserContracts

struct AdminGetUserIdentityDefaultController: AdminGetUserIdentityController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetUserIdentityInteractor,
            presenter: any AdminGetUserIdentityPresenter
        )

    func getUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Identities.read) else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        let id = try context.requiredID()
        do {
            let identity = try await interactor.load(id: id)
            let roleNames = try await interactor.roleNames(
                for: identity.roleIds
            )
            let model = AdminGetUserIdentityModel(
                details: .init(
                    id: identity.id,
                    status: identity.status,
                    roleIds: identity.roleIds
                ),
                roleNames: roleNames
            )
            return try await presenter.renderDetailsPage(
                model: model,
                permissions: context.currentUserAdminListActions
            )
        } catch let error as AdminGetUserIdentityError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

}
