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
        selectedIds: [String]
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected processors",
            content: NewAdminConfirmation(
                breadcrumb: MediaProcessorRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected processors",
                    description: "Confirm removal of the selected processors."
                ),
                selectedItems: selectedIds,
                action: MediaProcessorRoutes.remove.description,
                cancel: NewAdminLocation.url(
                    path: MediaProcessorRoutes.list.description,
                    page: pageState.page,
                    search: search
                ),
                submitLabel: "Remove selected"
            )
        )
    }

}
