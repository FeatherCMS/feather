import Hummingbird

struct AdminAddContactFormItem {
    let controller: any AdminAddContactFormItemController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFormItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormItemDefaultInteractor(
                        repository: AdminAddContactFormItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddContactFormItemDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
