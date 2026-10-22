import FeatherWebAdmin
import Hummingbird

extension Overview {
    struct Router {
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
            .route(on: router)
        }
    }
}
