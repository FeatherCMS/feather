import ContactContracts
import FeatherAdmin
import FeatherContracts
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
        let formKey = request.queryString("form")?.whitespaceTrimmed.emptyToNil
        do {
            let result = try await interactor.list(formKey: formKey)
            let fields = result.fields
                .filter {
                    search.isEmpty
                        || $0.key.localizedCaseInsensitiveContains(search)
                        || $0.label.localizedCaseInsensitiveContains(search)
                }
            return try await presenter.renderList(
                fields: fields,
                forms: result.forms,
                formKey: formKey,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderList(
                fields: [],
                forms: [],
                formKey: formKey,
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
