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

struct AdminListBlogAuthor {
    let controller: any AdminListBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogAuthorDefaultInteractor(
                        repository: AdminListBlogAuthorOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminListBlogAuthorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
