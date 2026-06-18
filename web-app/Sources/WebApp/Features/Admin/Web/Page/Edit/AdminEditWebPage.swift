import Hummingbird

struct AdminEditWebPage {
    let controller: any AdminEditWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebPageDefaultInteractor(
                        repository: AdminEditWebPageOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
