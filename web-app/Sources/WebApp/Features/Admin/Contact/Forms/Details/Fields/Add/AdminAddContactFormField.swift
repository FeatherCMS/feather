import Hummingbird

struct AdminAddContactFormField {
    let controller: any AdminAddContactFormFieldController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormFieldDefaultInteractor(
                        repository: AdminAddContactFormFieldOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddContactFormFieldDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
