import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import UserModule

extension Identity.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Identity.Detail.Interactor.Interface,
                any Identity.Detail.Presenter.Interface
            >

        func getUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Identity.Permissions.read
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            let id = try context.requiredID()
            do {
                let identity = try await interactor.load(id: id)
                let roleNames = try await interactor.roleNames(
                    for: identity.roleIds
                )
                let model = Identity.Detail.Model(
                    id: identity.id,
                    name: identity.name,
                    status: identity.status,
                    roleIds: identity.roleIds,
                    roleNames: roleNames
                )
                return try await presenter.renderDetailsPage(
                    model: model,
                    permissions: context.currentUserAdminListActions
                )
            }
            catch let error as Identity.Detail.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }

    }
}
