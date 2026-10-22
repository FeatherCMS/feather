import FeatherWebAdmin
import UserModule

extension Role.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            role: Role.Detail.RepositoryModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Role.Detail.Error) async throws
            -> HTMLResponse
    }
}
