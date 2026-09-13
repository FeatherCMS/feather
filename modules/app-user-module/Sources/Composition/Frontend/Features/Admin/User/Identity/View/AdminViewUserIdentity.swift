import FeatherAdmin
import Hummingbird

struct AdminViewUserIdentity {
    let controller: any AdminViewUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewUserIdentityDefaultController(
            buildRuntime: { request, context in
                let userAPI = context.userAdminAPI()
                return (
                    interactor: AdminViewUserIdentityDefaultInteractor(
                        repository: AdminViewUserIdentityOpenAPIRepository(
                            api: userAPI
                        ),
                        roleRepository:
                            AdminViewUserIdentityRoleOpenAPIRepository(
                                api: userAPI
                            )
                    ),
                    presenter: AdminViewUserIdentityDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
