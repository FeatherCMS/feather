import Hummingbird

struct AdminListWebMetadataDefaultController:
    AdminListWebMetadataController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListWebMetadataInteractor,
            presenter: any AdminListWebMetadataPresenter
        )

    func getMetadataEntries(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminWeb.Scope.metadata
        )
        let emptyModel = AdminListWebMetadataModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebMetadataModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listMetadataEntries(
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
        return presenter.renderListPage(
            model: model,
            isEdited: request.hasQueryFlag("edited"),
            permissions: permissions,
            search: search,
            error: error
        )
    }
}
