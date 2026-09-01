import FeatherAdmin
import Hummingbird

struct AdminGetUserIdentity {
    let controller: any AdminGetUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserIdentityDefaultController(
            buildRuntime: { request, context in
                let userAPI = context.userAdminAPI()
                return (
                    interactor: AdminGetUserIdentityDefaultInteractor(
                        repository: AdminGetUserIdentityOpenAPIRepository(
                            api: userAPI
                        ),
                        roleRepository:
                            AdminEditUserIdentityRoleOpenAPIRepository(
                                api: userAPI
                            )
                    ),
                    presenter: AdminGetUserIdentityDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
