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


extension Asset.Folder.Add {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.Folder.Add.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.Folder.Add.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Asset.Folder.Add.Interactor.Default(
                            repository: Asset.Folder.Add.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Asset.Folder.Add.Presenter.Default(
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
                routes.folder.add.routerPath,
                use: controller.getAddMediaFolder
            )
            router.post(
                routes.folder.add.routerPath,
                use: controller.postAddMediaFolder
            )
        }
    }
}
