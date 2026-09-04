import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminGetBlogAuthorLinkDefaultController: AdminGetBlogAuthorLinkController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetBlogAuthorLinkInteractor,
            presenter: any AdminGetBlogAuthorLinkPresenter
        )

    func getBlogAuthorLink(
        request: Request,
        context: DefaultRequestContext
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
