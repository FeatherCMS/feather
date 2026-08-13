import FeatherAdmin
import Hummingbird

struct AdminEditUserIdentity {
    let controller: any AdminEditUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserIdentityDefaultInteractor(
                        identityRepository:
                            AdminEditUserIdentityOpenAPIRepository(
                                api: context.userAdminAPI()
                            ),
                        roleRepository:
                            AdminEditUserIdentityRoleOpenAPIRepository(
                                api: context.userAdminAPI()
                            )
                    ),
                    presenter: AdminEditUserIdentityDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
