import HTML
import Hummingbird

struct AdminRemoveWebPageDefaultController:
    AdminRemoveWebPageController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveWebPageInteractor,
            presenter: any AdminRemoveWebPagePresenter
        )

    func getRemoveWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let page = try await runtime.interactor.get(id: id)
            return runtime.presenter.renderRemovePage(
                id: id,
                source: page.title,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postRemoveWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            try await runtime.interactor.delete(id: id)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/pages/",
                        title: "Removed",
                        message: "Web page removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try runtime.presenter
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
