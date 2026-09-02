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

struct AdminGetBlogAuthor {
    let controller: any AdminGetBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogAuthorDefaultInteractor(
                        repository: AdminGetBlogAuthorOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminGetBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
