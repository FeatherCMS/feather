import FeatherAdmin
import Hummingbird

struct AdminAddUserIdentity {
    let controller: any AdminAddUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserIdentityDefaultInteractor(
                        repository: AdminAddUserIdentityOpenAPIRepository(
                            api: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminAddUserIdentityDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
