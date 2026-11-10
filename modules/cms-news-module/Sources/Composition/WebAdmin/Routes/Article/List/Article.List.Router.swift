import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule
import WebModule
import WebModuleWebAdmin

extension Article.List {
    struct Router: Sendable {
        let controller: any Controller.Interface
        let routes: Article.Router.Routes
        let environment: AppEnvironment

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Article.Router.Routes
        ) {
            self.routes = routes
            self.environment = environment
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return Runtime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: api
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
            router.get(routes.list.routerPath, use: controller.getArticles)
            router.post(routes.status.routerPath) { request, context in
                let id = try context.requiredID()
                guard context.isCurrentUserAllowed(
                    to: Article.Permissions.update
                ) else {
                    return Response(status: .forbidden)
                }
                let payload = try await request.decode(
                    as: AdminStatusActionFormInput.self,
                    context: context
                )
                let api = API.Client(
                    environment: environment,
                    requestContext: context
                )
                let details = try await Article.Detail.Repository.OpenAPI(
                    api: api
                ).get(id: id)
                let current = details.metadata.adminValue(
                    template: "news.article"
                )
                let selectedStatus = payload.normalizedStatus
                let targetStatus = ["draft", "published", "archived"]
                    .contains(selectedStatus)
                    ? selectedStatus
                    : current.normalizedStatus
                try await WebModule.Metadata.Status.Repository.OpenAPI(
                    api: WebModuleWebAdmin.API.Client(
                        environment: environment,
                        requestContext: context
                    )
                ).update(
                    referenceType: "news.article",
                    referenceID: id,
                    status: targetStatus
                )
                let notification: AdminNotification.State = switch targetStatus {
                case "published":
                    .init(title: "Published", message: "News article published successfully.")
                case "archived":
                    .init(title: "Archived", message: "News article archived successfully.")
                default:
                    .init(title: "Draft", message: "News article moved to draft successfully.")
                }
                return AdminNotification.redirect(
                    to: payload.normalizedReturnTo ?? routes.list.path + "/",
                    notification: notification
                )
            }
        }
    }
}
