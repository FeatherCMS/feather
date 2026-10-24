import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension NotFound.View {
    struct Router {
        let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine
        ) {
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(
                AnalyticsWebAdmin.Router.Routes.notFound,
                use: controller.getNotFound
            )
        }
    }
}
