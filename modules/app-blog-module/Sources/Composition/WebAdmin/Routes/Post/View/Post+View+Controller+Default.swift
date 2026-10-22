import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Post.View.Interactor.Interface,
                any Post.View.Presenter.Interface
            >

        func getBlogPost(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
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
}
