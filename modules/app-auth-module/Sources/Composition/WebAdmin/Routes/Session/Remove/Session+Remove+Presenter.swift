import AuthModule
import FeatherWebAdmin
import FeatherWebShared

extension Session.Remove {
    enum Presenter {}
}

extension Session.Remove.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            item: AdminRemoveItemContext,
            identityId: String
        ) async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse

        func errorPage(
            item: AdminRemoveItemContext,
            identityId: String,
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse

    }
}
