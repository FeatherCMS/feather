import HTML
import Hummingbird

struct AdminGetWebMenuItemDefaultController: AdminGetWebMenuItemController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetWebMenuItemInteractor,
            presenter: any AdminGetWebMenuItemPresenter
        )

    func getWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions

        do {
            let rule = try await runtime.interactor.execute(
                entity: .init(menuId: menuId, id: id)
            )
            return runtime.presenter.renderDetailsPage(
                rule: rule,
                breadcrumb: runtime.presenter.breadcrumb(
                    menuId: menuId,
                    id: id
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: runtime.presenter.breadcrumb(
                    menuId: menuId,
                    id: id
                ),
                permissions: permissions
            )
        }
    }
}
