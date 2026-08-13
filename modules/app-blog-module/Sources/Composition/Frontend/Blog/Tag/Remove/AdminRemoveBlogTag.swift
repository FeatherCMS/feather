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

struct AdminRemoveBlogTag {
    let controller: any AdminRemoveBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogTagDefaultInteractor(
                        repository: AdminRemoveBlogTagOpenAPIRepository(
                            api: context.blogManagementAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
