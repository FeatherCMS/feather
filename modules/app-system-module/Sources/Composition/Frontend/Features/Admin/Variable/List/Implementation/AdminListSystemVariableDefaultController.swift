import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import SystemContracts

struct AdminListSystemVariableDefaultController:
    AdminListSystemVariableController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListSystemVariableInteractor,
            any AdminListSystemVariablePresenter
        >

    func getSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: SystemPermissions.Variables.list
        )
        guard canAccess else {
            return try await presenter.renderErrorPage(
                error: .forbidden
            )
        }
        do {
            let model = try await interactor.listSystemVariables(
                page: page,
                search: search
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: Set(permissions.map(PermissionKey.init)),
                search: search
            )
        }
        catch let error as AdminListSystemVariableError {
            return try await presenter.renderErrorPage(
                error: error
            )
        }
    }

}
