import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove.Interactor {
    protocol Interface: Sendable {

        func remove(ids: [String]) async throws
    }
}
