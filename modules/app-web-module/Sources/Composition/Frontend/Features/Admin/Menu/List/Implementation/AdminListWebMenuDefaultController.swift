import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebMenuDefaultController:
    AdminListWebMenuController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListWebMenuInteractor,
            any AdminListWebMenuPresenter
        >

    func getWebMenus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebPermissions.Menus.list
        )
        let emptyModel = AdminListWebMenuModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebMenuModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listWebMenus(
                    page: page,
                    search: search
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return try await presenter.renderListPage(
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
}
