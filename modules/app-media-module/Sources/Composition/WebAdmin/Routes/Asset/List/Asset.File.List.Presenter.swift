import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.List {
    enum Presenter {}
}

extension Asset.File.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: Asset.File.List.Model,
            search: String?,
            permissions: AdminListActions,
        ) async throws -> HTMLResponse

        func renderErrorPage(
            message: String,
            picker: Bool
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage(
            cancel: String
        ) async throws -> HTMLResponse
    }
}
