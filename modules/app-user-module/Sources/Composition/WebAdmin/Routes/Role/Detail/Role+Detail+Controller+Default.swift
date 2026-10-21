import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Role.Detail.Interactor.Interface,
                any Role.Detail.Presenter.Interface
            >

        func getUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: Role.Permissions.read
                )
            else {
                return try await runtime.presenter.renderErrorPage(
                    error: .forbidden
                )
            }
            let id = try context.requiredID()
            do {
                let role = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.renderDetailsPage(
                    role: role,
                    permissions: context.currentUserAdminListActions
                )
            }
            catch let error as Role.Detail.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
            }
        }
    }
}
