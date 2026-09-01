import AuthContracts
import FeatherAdmin
import Hummingbird

struct AdminListAuthSessionDefaultController:
    AdminListAuthSessionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListAuthSessionInteractor,
            presenter: AdminListAuthSessionDefaultPresenter
        )

    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        guard context.isCurrentUserAllowed(to: AuthPermissions.Sessions.list)
        else {
            return runtime.presenter.renderError(
                error: .forbidden(
                    message: "Your identity cannot access user sessions."
                ),
                identityID: try context.requiredID(),
                permissions: permissions
            )
        }

        let identityID = try context.requiredID()
        do {
            let model = try await runtime.interactor.list(
                identityID: identityID
            )
            return runtime.presenter.render(
                model: model,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderError(
                error: error,
                identityID: identityID,
                permissions: permissions
            )
        }
    }
}
