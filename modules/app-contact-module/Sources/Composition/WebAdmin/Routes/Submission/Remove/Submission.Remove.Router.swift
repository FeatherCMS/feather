import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Submission.Router.Routes

        init(
            environment: AppEnvironment,
            routes: Submission.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildInteractor: { _, context in
                    Interactor.Default(
                        repository: Repository.OpenAPI(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(
                routes.submissionsRemove.routerPath,
                use: controller.remove
            )
            router.post(
                routes.formSubmissionRemoveSelected.routerPath,
                use: controller.removeForForm
            )
        }
    }
}
