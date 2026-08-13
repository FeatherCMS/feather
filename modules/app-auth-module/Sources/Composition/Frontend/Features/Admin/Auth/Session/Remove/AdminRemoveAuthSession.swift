import FeatherAdmin
import Hummingbird
import UserFrontend

struct AdminRemoveAuthSession {
    let controller: any AdminRemoveAuthSessionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAuthSessionDefaultController(
            buildRuntime: { request, context in
                let api = context.authAdminAPI()
                let userAPI = context.userAdminAPI()
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
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
