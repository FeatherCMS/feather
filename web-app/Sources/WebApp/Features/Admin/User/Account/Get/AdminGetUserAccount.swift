import Hummingbird

struct AdminGetUserAccount {
    let controller: any AdminGetUserAccountController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserAccountDefaultController(
            buildRuntime: { request, context in
                let api = context.managementAPI()
                return (
                    interactor: AdminGetUserAccountDefaultInteractor(
                        repository: AdminGetUserAccountOpenAPIRepository(
                            api: api
                        )
                    ),
                    removeSessionInteractor:
                        AdminRemoveUserAccountSessionDefaultInteractor(
                            repository:
                                AdminRemoveUserAccountSessionOpenAPIRepository(
                                    api: api
                                )
                        ),
                    presenter: AdminGetUserAccountDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    ),
                    roleRepository: AdminEditUserAccountRoleOpenAPIRepository(
                        api: api
                    )
                )
            }
        )
    }
}
