import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Asset.Router.Routes

        func renderPage(
            model: Asset.Folder.Add.Model
        ) async throws -> HTMLResponse {
            let isDialog = request.queryString("presentation") == "dialog"
            let content = MediaFolderAddView(
                state: .init(
                    routes: routes,
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
                return try await renderEngine.renderAdminDialog(
                    request: request,
                    context: context,
                    title: "Add media folder",
                    content: content,
                    size: .small
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add media folder",
                content: content
            )
        }

    }
}
