import Hummingbird

struct AdminListAuthCredentialAccount {
    let controller: any AdminListAuthCredentialAccountController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListAuthCredentialAccountDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthCredentialAccountDefaultInteractor(
                        repository: AdminListAuthCredentialAccountOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListAuthCredentialAccountDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
