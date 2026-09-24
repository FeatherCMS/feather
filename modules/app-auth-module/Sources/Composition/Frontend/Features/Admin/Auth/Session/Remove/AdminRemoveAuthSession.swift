import FeatherAdmin
import Hummingbird
import UserFrontend

struct AdminRemoveAuthSession {
    let controller: any AdminRemoveAuthSessionController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveAuthSessionDefaultController(
            buildRuntime: { request, context in
                let api = apiBuilder.makeAuthAdmin(context)
                let userAPI = apiBuilder.makeUserAdmin(context)
                return (
                    interactor: AdminRemoveAuthSessionDefaultInteractor(
                        repository:
                            AdminRemoveAuthSessionOpenAPIRepository(
                                api: api,
                                userAPI: userAPI
                            )
                    ),
                    presenter: AdminRemoveAuthSessionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
