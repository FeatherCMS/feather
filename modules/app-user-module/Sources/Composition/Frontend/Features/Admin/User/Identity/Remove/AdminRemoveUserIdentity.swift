import FeatherAdmin
import Hummingbird

struct AdminRemoveUserIdentity {
    let controller: any AdminRemoveUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserIdentityDefaultController(
            buildRuntime: { request, context in
                let api = context.userAdminAPI()
                return (
                    interactor: AdminRemoveUserIdentityDefaultInteractor(
                        repository: AdminRemoveUserIdentityOpenAPIRepository(
                            api: api
                        )
                    ),
                    presenter: AdminRemoveUserIdentityDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
