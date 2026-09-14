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

struct AdminRemoveBlogTagDefaultController:
    AdminRemoveBlogTagController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveBlogTagInteractor,
            presenter: any AdminRemoveBlogTagPresenter
        )

    func getRemoveBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let page = try await runtime.interactor.get(id: id)
            return try await runtime.presenter.renderRemovePage(
                id: id,
                source: page.title,
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

    func postRemoveBlogTag(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            try await runtime.interactor.delete(id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/blog/tags/",
                notification: .init(
                    title: "Removed",
                    message: "Blog tag removed successfully."
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
