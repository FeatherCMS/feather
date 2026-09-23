import FeatherAdmin
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
        AuthenticatedRuntimeBuilder<
            any AdminListContactFormsInteractor,
            any AdminListContactFormsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
