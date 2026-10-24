import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.File.Add.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.File.Add.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Asset.File.Add.Interactor.Default(
                            repository: Asset.File.Add.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context,
                                    timeoutSeconds: 60 * 60
                                )
                            ),
                            routes: routes
                        ),
                        presenter: Asset.File.Add.Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine,
                            routes: routes
                        )
                    )
                },
                routes: routes
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.file.add.routerPath,
                use: controller.getAddMediaAsset
            )
            router.post(
                routes.file.add.routerPath,
                use: controller.postAddMediaAsset
            )
        }
    }
}
