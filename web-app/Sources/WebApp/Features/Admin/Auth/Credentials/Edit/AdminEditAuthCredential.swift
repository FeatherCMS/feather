import Hummingbird

struct AdminEditAuthCredential {
    let controller: any AdminEditAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthCredentialDefaultInteractor(
                        repository: AdminEditAuthCredentialOpenAPIRepository(api: context.managementAPI())
                    ),
                    presenter: AdminEditAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
