import Hummingbird

struct AdminRemoveUserAccount {
    let controller: any AdminRemoveUserAccountController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserAccountDefaultController(
            buildRuntime: { request, context in
                let api = context.managementAPI()
                return (
                    getInteractor: AdminGetUserAccountDefaultInteractor(
                        repository: AdminGetUserAccountOpenAPIRepository(
                            api: api
                        )
                    ),
                    removeInteractor: AdminRemoveUserAccountDefaultInteractor(
                        repository: AdminRemoveUserAccountOpenAPIRepository(
                            api: api
                        )
                    ),
                    presenter: AdminRemoveUserAccountDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
