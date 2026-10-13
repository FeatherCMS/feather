import FeatherAdmin
import Hummingbird

protocol AdminEditMediaVariantController: Sendable {
    func getEditMediaVariant(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    func getEditMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func getRemoveMediaVariantProcessors(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func postEditMediaVariant(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    func postAddMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func postEditMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func postRemoveMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditMediaVariantController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(MediaVariantRoutes.editRoute, use: getEditMediaVariant)
        router.get(
            MediaVariantRoutes.processorEditRoute,
            use: getEditMediaVariantProcessor
        )
        router.get(
            MediaVariantRoutes.processorRemoveRoute,
            use: getRemoveMediaVariantProcessors
        )
        router.post(MediaVariantRoutes.editRoute, use: postEditMediaVariant)
        router.post(
            MediaVariantRoutes.processorAddRoute,
            use: postAddMediaVariantProcessor
        )
        router.post(
            MediaVariantRoutes.processorEditRoute,
            use: postEditMediaVariantProcessor
        )
        router.post(
            MediaVariantRoutes.processorRemoveRoute,
            use: postRemoveMediaVariantProcessor
        )
    }
}
