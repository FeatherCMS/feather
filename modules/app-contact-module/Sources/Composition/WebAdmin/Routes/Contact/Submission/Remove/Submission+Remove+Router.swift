import ContactApplication
import ContactModule
import ContactWebShared
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Remove {
    struct Router {
        let controller: any Controller.Interface

        init(
            apiBuilder: ContactAPIBuilder,
            renderingEngine: any RenderingEngine
        ) {
            controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeContactAdmin(context)
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

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            controller.route(on: router)
        }
    }
}
