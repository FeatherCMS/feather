import Hummingbird

struct AdminListAuthCredential {
    let controller: any AdminListAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthCredentialDefaultInteractor(
                        repository: AdminListAuthCredentialOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
