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

extension Asset.File.Remove {
    enum Presenter {}
}

extension Asset.File.Remove.Presenter {
    protocol Interface: Sendable {

        func renderRemovePage(model: Asset.File.Remove.Model)
            async throws -> HTMLResponse

    }
}
