import Hummingbird

struct AdminRemoveWebPage {
    let controller: any AdminRemoveWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebPageDefaultInteractor(
                        repository: AdminRemoveWebPageOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
