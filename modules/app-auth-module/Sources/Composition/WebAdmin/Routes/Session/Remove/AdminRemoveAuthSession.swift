import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserWebAdmin

struct AdminRemoveAuthSession {
    let controller: any AdminRemoveAuthSessionController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveAuthSessionDefaultController(
            buildRuntime: { request, context in
                let api = API.Client(
                    environment: environment,
                    requestContext: context
                )
                let userAPI = UserWebAdmin.API.Client(
                    apiBaseURL: environment.apiBaseURL,
                    requestContext: context
                )
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
