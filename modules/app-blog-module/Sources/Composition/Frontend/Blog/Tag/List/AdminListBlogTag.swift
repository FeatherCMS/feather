import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminListBlogTag {
    let controller: any AdminListBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogTagDefaultInteractor(
                        repository: AdminListBlogTagOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminListBlogTagDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
