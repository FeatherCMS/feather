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
import WebStandards

struct AdminEditBlogTag {
    let controller: any AdminEditBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogTagDefaultInteractor(
                        repository: AdminEditBlogTagOpenAPIRepository(
                            api: context.blogManagementAPI()
                        )
                    ),
                    presenter: AdminEditBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
