import FeatherAdmin
import Hummingbird

struct AdminViewAccountInvitationDefaultController:
    AdminViewAccountInvitationController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAccountInvitationInteractor,
            any AdminViewAccountInvitationPresenter
        >

    func getAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let invitation = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            let roleNames = await runtime.interactor.roleNames(
                for: invitation.roleIds
            )
            return try await runtime.presenter.renderDetailsPage(
                invitation: .init(
                    id: invitation.id,
                    email: invitation.email,
                    roleIds: invitation.roleIds,
                    roleNames: roleNames
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
