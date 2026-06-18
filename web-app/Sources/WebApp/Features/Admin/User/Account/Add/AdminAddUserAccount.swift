import Hummingbird

struct AdminAddUserAccount {
    let controller: any AdminAddUserAccountController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddUserAccountDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserAccountDefaultInteractor(
                        repository: AdminAddUserAccountOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddUserAccountDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
