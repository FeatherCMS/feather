import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminGetAuthEmailDefaultController: AdminGetAuthEmailController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAuthEmailInteractor,
            presenter: any AdminGetAuthEmailPresenter
        )

    func getAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        let permissions = context.currentUserPermissions
        do {
            let link = try await interactor.execute(
                entity: .init(id: id)
            )
            return presenter.renderPage(
                link: link,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                id: id,
                error: error,
                permissions: permissions
            )
        }
    }
}
