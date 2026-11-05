import FeatherWebAdmin
import UserModule

extension Role.Detail {
    enum Presenter {}
}

extension Role.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            role: Role.Detail.Repository.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Role.Detail.Error) async throws
            -> HTMLResponse
    }
}
