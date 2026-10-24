import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Edit {
    enum Controller {}
}

extension Variant.Edit.Controller {
    protocol Interface: Sendable {
        func getEditMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        func getEditMediaVariantProcessor(
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
}
