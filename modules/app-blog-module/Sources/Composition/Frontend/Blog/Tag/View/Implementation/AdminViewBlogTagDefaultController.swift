import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogTagDefaultController: AdminViewBlogTagController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewBlogTagInteractor,
            presenter: any AdminViewBlogTagPresenter
        )

    func getBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let rule = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return try await runtime.presenter.renderDetailsPage(
                rule: rule,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
