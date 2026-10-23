import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Contact.Router.Routes

        init(
            environment: AppEnvironment,
            routes: Contact.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildInteractor: { _, context in
                    Interactor.Default(
                        repository: Repository.OpenAPI(
                            api: API.Client(
                                apiBaseURL: environment.apiBaseURL,
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
