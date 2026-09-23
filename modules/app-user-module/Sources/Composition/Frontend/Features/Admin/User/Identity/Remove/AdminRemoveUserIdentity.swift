import FeatherAdmin
import Hummingbird

struct AdminRemoveUserIdentity {
    let controller: any AdminRemoveUserIdentityController

    init(apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserIdentityDefaultController(
            buildRuntime: { request, context in
                let api = apiBuilder.makeUserAdmin(context)
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
