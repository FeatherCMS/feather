import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaFolderDefaultPresenter: AdminAddMediaFolderPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaFolderModel
    ) async throws -> HTMLResponse {
        let isDialog = request.queryString("presentation") == "dialog"
        let content = MediaFolderAddView(
            state: .init(
                form: .init(
                    parentId: model.parentId ?? "",
                    name: model.name,
                    view: model.view,
                    error: model.error
                ),
                isDialog: isDialog
            )
        )
        if isDialog {
            return try await renderEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: "Add media folder",
                content: content,
                size: .small
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add media folder",
            content: content
        )
    }

}
