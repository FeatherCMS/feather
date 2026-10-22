import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Processor {
    enum List {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
}

extension Variant.Processor.List {
    struct Router {
        private let routes: Variant.Router.Routes
        let controller: any Variant.Processor.List.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variant.Router.Routes
        ) {
            self.routes = routes
            self.controller = Variant.Processor.List.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor:
                            Variant.Processor.List.Interactor.Default(
                                repository:
                                    Variant.Processor.List.Repository.OpenAPI(
                                        api: MediaAdminAPIClient(
                                            environment: environment,
                                            requestContext: context
                                        )
                                    )
                            ),
                        presenter: Variant.Processor.List.Presenter.Default(
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
                routes.processors.routerPath,
                use: controller.getMediaVariantProcessors
            )
            router.get(
                routes.processorAdd.routerPath,
                use: controller.getAddMediaVariantProcessor
            )
        }
    }
}
