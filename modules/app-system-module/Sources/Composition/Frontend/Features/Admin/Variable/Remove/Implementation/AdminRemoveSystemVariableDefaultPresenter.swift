import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveSystemVariableDefaultPresenter:
    AdminRemoveSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        return try await renderingEngine.renderNewAdminPage(request: request, context: context, title: "Manage system variables",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        fromDetails: Bool
    ) async throws -> HTMLResponse {
        return try await renderingEngine.renderNewAdminPage(request: request, context: context, title: "Manage system variables",
            content: NewAdminConfirmation(
                breadcrumb: SystemVariableRoutes.breadcrumb,
                title: "Remove selected variables",
                message:
                    "You’re about to permanently remove the selected system variables. This action cannot be undone.",
                selectedIDs: ids,
                selectedNames: names,
                action: SystemVariableRoutes.remove.description,
                cancel: fromDetails && ids.count == 1
                    ? SystemVariableRoutes.details(RouterPath(ids[0]))
                        .description
                    : ids.count == 1
                        ? SystemVariableRoutes.edit(RouterPath(ids[0]))
                            .description
                        : ListRemoveRedirect.location(
                            path: SystemVariableRoutes.list.description,
                            page: page,
                            search: search,
                            title: nil,
                            message: nil
                        ),
                hiddenFields: ids.map {
                    .init(name: "ids", value: $0)
                }
            )
        )
    }


}
