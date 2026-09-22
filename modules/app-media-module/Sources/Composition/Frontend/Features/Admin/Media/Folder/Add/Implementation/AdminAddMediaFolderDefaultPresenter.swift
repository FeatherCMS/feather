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
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaFolderModel
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add media folder",
            content: MediaFolderAddView(
                state: .init(
                    form: .init(
                        parentId: model.parentId ?? "",
                        name: model.name,
                        view: model.view,
                        error: model.error
                    )
                )
            )
        )
    }

}
