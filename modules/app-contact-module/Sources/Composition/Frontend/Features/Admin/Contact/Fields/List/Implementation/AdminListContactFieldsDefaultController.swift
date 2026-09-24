import ContactContracts
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsDefaultController:
    AdminListContactFieldsController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListContactFieldsInteractor,
            any AdminListContactFieldsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.list)
        else {
            return try await presenter.renderForbiddenPage()
        }
        let search = request.querySearch() ?? ""
        do {
            let fields = try await interactor.list()
                .filter {
                    search.isEmpty
                        || $0.key.localizedCaseInsensitiveContains(search)
                        || $0.label.localizedCaseInsensitiveContains(search)
                }
            return try await presenter.renderList(
                fields: fields,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderList(
                fields: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
