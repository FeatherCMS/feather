import FeatherAdmin
import Hummingbird

struct AdminViewUserIdentity {
    let controller: any AdminViewUserIdentityController

    init(
        apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewUserIdentityDefaultController(
            buildRuntime: { request, context in
                let userAPI = apiBuilder.makeUserAdmin(context)
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
