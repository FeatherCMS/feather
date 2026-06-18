import HTML
import Hummingbird

struct AdminGetBlogPostDefaultController: AdminGetBlogPostController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetBlogPostInteractor,
            presenter: any AdminGetBlogPostPresenter
        )

    func getBlogPost(
        request: Request,
        context: AppRequestContext
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
