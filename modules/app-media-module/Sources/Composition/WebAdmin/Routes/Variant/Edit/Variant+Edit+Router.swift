import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Edit {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
}

extension Variant.Edit {
    struct Router {
        private let routes: Variant.Router.Routes
        let controller: any Variant.Edit.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variant.Router.Routes
        ) {
            self.routes = routes
            self.controller = Variant.Edit.Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Variant.Edit.Interactor.Default(
                            repository: Variant.Edit.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Variant.Edit.Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.edit.routerPath,
                use: controller.getEditMediaVariant
            )
            router.get(
                routes.processorEdit.routerPath,
                use: controller.getEditMediaVariantProcessor
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditMediaVariant
            )
            router.post(
                routes.processorAdd.routerPath,
                use: controller.postAddMediaVariantProcessor
            )
            router.post(
                routes.processorEdit.routerPath,
                use: controller.postEditMediaVariantProcessor
            )
            router.post(
                routes.processorRemove.routerPath,
                use: controller.postRemoveMediaVariantProcessor
            )
        }
    }
}
