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

struct AdminAddBlogAuthor {
    let controller: any AdminAddBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogAuthorDefaultInteractor(
                        repository: AdminAddBlogAuthorOpenAPIRepository(
                            api: context.blogManagementAPI()
                        )
                    ),
                    presenter: AdminAddBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
