import FeatherAdmin
import HTML
import Hummingbird

struct AdminGetAccountInvitationDefaultController:
    AdminGetAccountInvitationController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAccountInvitationInteractor,
            presenter: any AdminGetAccountInvitationPresenter,
            roleNames: @Sendable ([String]) async -> [String]
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
            let roleNames = await runtime.roleNames(invitation.roleIds)
            return runtime.presenter.renderDetailsPage(
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
            return runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
    }
}
