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

struct AdminListContactFormsDefaultController: AdminListContactFormsController {
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListContactFormsInteractor,
            any AdminListContactFormsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list()
                .filter {
                    search.isEmpty
                        || $0.name.localizedCaseInsensitiveContains(search)
                }
            return try await presenter.renderList(
                items: items,
                search: search,
                isPicker: request.hasQueryFlag("picker"),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderList(
                items: [],
                search: search,
                isPicker: request.hasQueryFlag("picker"),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

}
