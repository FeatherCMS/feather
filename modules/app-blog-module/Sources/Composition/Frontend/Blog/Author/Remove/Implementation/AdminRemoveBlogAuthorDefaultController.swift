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

struct AdminRemoveBlogAuthorDefaultController:
    AdminRemoveBlogAuthorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveBlogAuthorInteractor,
            presenter: any AdminRemoveBlogAuthorPresenter
        )

    func getRemoveBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let menu = try await runtime.interactor.get(id: id)
            return try await runtime.presenter.renderRemovePage(
                id: id,
                source: menu.name,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postRemoveBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            try await runtime.interactor.delete(id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/blog/authors/",
                notification: .init(
                    title: "Removed",
                    message: "Blog author removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
