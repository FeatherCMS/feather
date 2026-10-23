import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormSubmissionsDefaultController:
    AdminListContactFormSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListContactFormSubmissionsInteractor,
            any AdminListContactFormSubmissionsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let formId = try context.requiredParameter("formKey")
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list(formId: formId)
                .filter {
                    search.isEmpty
                        || $0.status.localizedCaseInsensitiveContains(search)
                        || $0.createdAt.localizedCaseInsensitiveContains(search)
                }
            return try await presenter.renderList(
                formId: formId,
                items: items,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderList(
                formId: formId,
                items: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
