import FeatherAdmin
import Hummingbird

struct AdminNewsArticles: Sendable {
    let apiBuilder: NewsAPIBuilder
    let renderingEngine: any RenderingEngine

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        let buildRuntime: AdminNewsArticleRuntimeBuilder = {
            request,
            context in
            let api = apiBuilder.makeNewsAdmin(context)
            return AdminNewsArticleRuntime(
                interactor: AdminNewsArticleDefaultInteractor(
                    repository: AdminNewsArticleOpenAPIRepository(api: api)
                ),
                presenter: AdminNewsArticleDefaultPresenter(
                    request: request,
                    context: context,
                    mediaAPI: api.mediaAdminAPI(),
                    renderingEngine: renderingEngine
                )
            )
        }
        AdminListNewsArticleDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminAddNewsArticleDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminViewNewsArticleDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminEditNewsArticleDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminRemoveNewsArticleDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
    }
}
