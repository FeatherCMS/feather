import HTML
import Hummingbird

struct AdminGetUserInvitationDefaultController:
    AdminGetUserInvitationController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetUserInvitationInteractor,
            presenter: any AdminGetUserInvitationPresenter
        )

    func getUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let invitation = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return runtime.presenter.renderDetailsPage(
                invitation: invitation,
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
