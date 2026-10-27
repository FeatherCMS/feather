import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebComponents
import WebModule

extension Page.Edit.Template.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Page.Router.Routes

        func render(
            model: Page.Edit.Template.Model
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit page template",
                content: Page.Edit.Template.Component(
                    model: model,
                    breadcrumb: routes.breadcrumb,
                    action: routes.templatePath(
                        pageID: model.pageID,
                        metadataID: model.metadataID
                    ),
                    detailsHref: routes.editPath(model.pageID),
                    metadataHref: routes.metadataPath(
                        pageID: model.pageID,
                        metadataID: model.metadataID
                    )
                )
            )
        }
    }
}
