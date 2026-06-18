import Hummingbird

struct AdminListUserAccount {
    let controller: any AdminListUserAccountController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListUserAccountDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserAccountDefaultInteractor(
                        repository: AdminListUserAccountOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListUserAccountDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
