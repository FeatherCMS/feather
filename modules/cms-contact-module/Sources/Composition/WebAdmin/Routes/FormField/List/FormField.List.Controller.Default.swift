import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any FormField.List.Interactor.Interface,
                any FormField.List.Presenter.Interface
            >

        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: FormField.Permissions.list
                )
            else {
                return try await presenter.renderForbiddenPage()
            }
            let search = request.querySearch() ?? ""
            let formKey = request.queryString("form")?.whitespaceTrimmed
                .emptyToNil
            do {
                let result = try await interactor.search(
                    page: request.queryPage(),
                    search: search,
                    formKey: formKey
                )
                return try await presenter.renderList(
                    fields: result.fields,
                    forms: result.forms,
                    total: result.total,
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
                    total: 0,
                    formKey: formKey,
                    search: search,
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }
    }
}
