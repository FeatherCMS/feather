import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.View {
    struct Router {
        let renderingEngine: any RenderingEngine

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            let controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
            router.get(
                AnalyticsWebAdmin.Router.Routes.analytics.routerPath,
                use: controller.getOverview
            )
        }
    }
}
