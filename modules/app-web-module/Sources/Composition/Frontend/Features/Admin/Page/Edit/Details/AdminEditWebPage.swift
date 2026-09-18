import FeatherAdmin
import Hummingbird
import MediaFrontend
import OpenAPIRuntime

struct AdminEditWebPage {
    let controller: any AdminEditWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebPageDefaultInteractor(
                        repository: AdminEditWebPageOpenAPIRepository(
                            api: context.webAdminAPI(),
                            mediaAPI: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminEditWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
