import FeatherAdmin
import Hummingbird

struct AdminListUserIdentity {
    let controller: any AdminListUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserIdentityDefaultInteractor(
                        repository: AdminListUserIdentityOpenAPIRepository(
                            api: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminListUserIdentityDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
