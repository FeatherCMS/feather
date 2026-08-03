import Hummingbird

struct AdminRemoveAuthCredential {
    let controller: any AdminRemoveAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthCredentialDefaultInteractor(
                        repository: AdminRemoveAuthCredentialOpenAPIRepository(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
