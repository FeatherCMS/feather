import UserContracts
import FeatherAdmin
import HTML
import Hummingbird

struct AdminGetUserIdentityDefaultController: AdminGetUserIdentityController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetUserIdentityInteractor,
            presenter: any AdminGetUserIdentityPresenter,
            roleRepository: AdminEditUserIdentityRoleOpenAPIRepository
        )

    func getUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter, roleRepository) = buildRuntime(
            request,
            context
        )
        let id = try context.requiredID()
        do {
            let identity = try await interactor.execute(id: id)
            let roleLookup = Dictionary(
                uniqueKeysWithValues:
                    try await roleRepository.list().map { ($0.id, $0.name) }
            )
            let model = AdminGetUserIdentityModel(
                details: .init(
                    id: identity.id,
                    status: identity.status,
                    roleIds: identity.roleIds
                ),
                roleNames: identity.roleIds.compactMap { roleLookup[$0] }
            )
            return presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.errorPage(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

}
