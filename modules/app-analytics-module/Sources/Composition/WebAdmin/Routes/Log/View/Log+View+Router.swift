import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.View {
    struct Router {
        let controller: any Controller.Interface

        init(
            apiBuilder: AnalyticsAdminAPIBuilder,
            renderingEngine: any RenderingEngine
        ) {
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeAnalyticsAdmin(context)
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
                AnalyticsWebAdmin.Router.Routes.log(RouterPath("{id}")),
                use: controller.getAnalyticsLog
            )
        }
    }
}
