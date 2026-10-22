import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.List {
    struct Router {
        let controller: any Session.List.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine
        ) {
            controller = Session.List.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Session.List.Interactor.Default(
                            repository: Session.List.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Session.List.Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
        }
    }
}
