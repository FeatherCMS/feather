import ContactApplication
import ContactModule
import ContactWebShared
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Search {
    struct Router {
        static let pageSize = 20

        let controller: any Controller.Interface
        let routes: Contact.Router.Routes

        init(
            apiBuilder: ContactAPIBuilder,
            renderingEngine: any RenderingEngine,
            routes: Contact.Router.Routes
        ) {
            self.routes = routes
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
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.submissions.routerPath, use: controller.list)
            router.get(
                routes.formSubmissions.routerPath,
                use: controller.listForForm
            )
        }
    }
}
