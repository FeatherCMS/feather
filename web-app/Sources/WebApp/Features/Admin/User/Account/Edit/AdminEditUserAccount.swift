import Hummingbird

struct AdminEditUserAccount {
    let controller: any AdminEditUserAccountController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserAccountDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserAccountDefaultInteractor(
                        accountRepository:
                            AdminEditUserAccountOpenAPIRepository(
                                api: context.managementAPI()
                            ),
                        roleRepository:
                            AdminEditUserAccountRoleOpenAPIRepository(
                                api: context.managementAPI()
                            )
                    ),
                    presenter: AdminEditUserAccountDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
