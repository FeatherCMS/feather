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
        let id = try context.requiredID()
        do {
            let identity = try await interactor.execute(id: id)
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
