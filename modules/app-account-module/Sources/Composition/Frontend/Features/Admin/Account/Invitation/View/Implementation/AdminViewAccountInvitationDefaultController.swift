import FeatherAdmin
import HTML
import Hummingbird

struct AdminViewAccountInvitationDefaultController:
    AdminViewAccountInvitationController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAccountInvitationInteractor,
            presenter: any AdminViewAccountInvitationPresenter
        )

    func getAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
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
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
    }
}
