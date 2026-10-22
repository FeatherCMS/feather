import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Session.List.Interactor.Interface,
                any Session.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let permissions = context.currentUserPermissions
            guard
                context.isCurrentUserAllowed(
                    to: Session.Permissions.list
                )
            else {
                return try await runtime.presenter.renderError(
                    error: .forbidden,
                    identityID: try context.requiredID(),
                    permissions: permissions
                )
            }

            let identityID = try context.requiredID()
            do {
                let model = try await runtime.interactor.list(
                    identityID: identityID
                )
                return try await runtime.presenter.render(
                    model: model,
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderError(
                    error: error,
                    identityID: identityID,
                    permissions: permissions
                )
            }
        }
    }
}
