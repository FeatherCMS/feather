import FeatherAdmin
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
        AuthenticatedRuntimeBuilder<
            any AdminListContactFormSubmissionsInteractor,
            any AdminListContactFormSubmissionsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
