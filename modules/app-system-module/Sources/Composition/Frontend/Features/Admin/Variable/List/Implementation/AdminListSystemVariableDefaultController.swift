import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import SystemContracts

struct AdminListSystemVariableDefaultController:
    AdminListSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListSystemVariableInteractor,
            presenter: any AdminListSystemVariablePresenter
        )

    func getSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: SystemPermissions.Variables.list
        )
        let model:
            AdminListModel<Components.Schemas.SystemVariableListItemSchema>?
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listSystemVariables(
                    page: page,
                    search: search
                )
                error = nil
            }
            catch let caughtError {
                model = nil
                error = caughtError.displayMessage
            }
        }
        else {
            model = nil
            error = nil
        }
        return try await presenter.renderListPage(
            model: model,
            notification: AdminNotificationFlash.notification(from: request),
            permissions: permissions,
            search: search,
            error: error,
            accessDenied: !canAccess
        )
    }

}
