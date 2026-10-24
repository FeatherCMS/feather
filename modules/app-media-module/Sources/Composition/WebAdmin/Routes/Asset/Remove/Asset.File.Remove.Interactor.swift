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
    enum Interactor {}
}

extension Asset.File.Remove.Interactor {
    protocol Interface: Sendable {

        func remove(ids: [String]) async throws
    }
}
