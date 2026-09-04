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

struct AdminGetBlogTagDefaultController: AdminGetBlogTagController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetBlogTagInteractor,
            presenter: any AdminGetBlogTagPresenter
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
            return runtime.presenter.renderDetailsPage(
                rule: rule,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions,
                isPublished: request.hasQueryFlag("published"),
                isUnpublished: request.hasQueryFlag("unpublished")
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
