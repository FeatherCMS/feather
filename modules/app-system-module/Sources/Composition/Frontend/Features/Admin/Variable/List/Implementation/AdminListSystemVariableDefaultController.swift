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
        guard canAccess else {
            return try await presenter.renderErrorPage(
                title: "Forbidden",
                message: "Your account cannot access system variables."
            )
        }
        do {
            let model = try await interactor.listSystemVariables(page: page, search: search)
            return try await presenter.renderListPage(
                model: model,
                permissions: permissions,
                search: search
            )
        }
        catch {
            return try await presenter.renderErrorPage(
                title: "Unable to load system variables.",
                message: error.displayMessage
            )
        }
    }

}
