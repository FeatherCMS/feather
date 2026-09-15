import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaProcessorDefaultPresenter: AdminListMediaProcessorPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<
            Components.Schemas.MediaProcessorListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media processors",
            content: MediaProcessorsListView(
                items: model.items,
                pageState: model.pageState,
                search: search,
                permissions: permissions
            )
        )
    }

    func renderErrorPage(
        message: String
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media processors",
            content: MediaProcessorErrorView(
                info: message
            )
        )
    }

    func renderRemoveConfirmation(
        pageState: NewAdminListPageState,
        search: String?,
        selectedIds: [String],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: MediaProcessorRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected processors",
            content: NewAdminRemoveConfirmation(
                breadcrumb: MediaProcessorRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected processors",
                    description: "Confirm removal of the selected processors."
                ),
                selectedItems: selectedIds,
                action: MediaProcessorRoutes.remove.description,
                cancel: cancel,
                submitLabel: "Remove selected",
                nonceToken: nonceToken,
                hiddenFields: selectedIds.map {
                    .init(name: "ids", value: $0)
                } + [
                    .init(name: "page", value: String(pageState.page)),
                    .init(name: "search", value: search ?? ""),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse {
        let page = try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media processors",
            content: NewAdminStatusView(
                state: .init(
                    title: "Confirmation expired",
                    message:
                        "This confirmation is no longer valid. Please try again."
                ),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: .badRequest)
    }

}
