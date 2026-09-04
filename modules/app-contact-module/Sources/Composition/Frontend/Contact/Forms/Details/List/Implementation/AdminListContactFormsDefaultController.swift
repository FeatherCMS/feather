import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormsDefaultController: AdminListContactFormsController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListContactFormsInteractor,
            presenter: any AdminListContactFormsPresenter
        )

    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list()
                .filter {
                    search.isEmpty
                        || $0.name.localizedCaseInsensitiveContains(search)
                }
            return presenter.renderList(
                items: items,
                search: search,
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                isPicker: request.hasQueryFlag("picker"),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderList(
                items: [],
                search: search,
                isAdded: false,
                isEdited: false,
                isRemoved: false,
                isPicker: request.hasQueryFlag("picker"),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

}
