import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserWebAdmin

extension Session.Remove {
    struct Router {
        let controller: any Session.Remove.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Session.Router.Routes
        ) {
            self.controller = Session.Remove.Controller.Default(
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    let userAPI = UserWebAdmin.API.Client(
                        apiBaseURL: environment.apiBaseURL,
                        requestContext: context
                    )
                    return WebAdminRuntime(
                        interactor: Session.Remove.Interactor.Default(
                            repository:
                                Session.Remove.Repository.OpenAPI(
                                    api: api,
                                    userAPI: userAPI
                                )
                        ),
                        presenter: Session.Remove.Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }
    }
}
