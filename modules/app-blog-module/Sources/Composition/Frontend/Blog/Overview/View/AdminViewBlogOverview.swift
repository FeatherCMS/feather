import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogOverview {
    let controller: any AdminViewBlogOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewBlogOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewBlogOverviewDefaultInteractor(),
                    presenter: AdminViewBlogOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
