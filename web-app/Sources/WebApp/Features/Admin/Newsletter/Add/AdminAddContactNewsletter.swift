import Hummingbird

struct AdminAddContactNewsletter {
    let controller: any AdminAddContactNewsletterController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactNewsletterDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactNewsletterDefaultInteractor(
                        repository: AdminAddContactNewsletterOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddContactNewsletterDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
