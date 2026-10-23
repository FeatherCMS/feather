import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import WebModule

struct Settings.Edit.Router {
    let controller: any Settings.Edit.Controller.Interface

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Settings.Router.Routes
    ) {
        self.controller = Settings.Edit.Controller.Default(
            routes: routes,
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: Settings.Edit.Interactor.Default(
                        repository: Settings.Edit.Repository.OpenAPI(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: Settings.Edit.Presenter.Default(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
