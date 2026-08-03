import Hummingbird

struct AdminAddAuthCredential {
    let controller: any AdminAddAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthCredentialDefaultInteractor(
                        repository: AdminAddAuthCredentialOpenAPIRepository(api: context.managementAPI())
                    ),
                    presenter: AdminAddAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
