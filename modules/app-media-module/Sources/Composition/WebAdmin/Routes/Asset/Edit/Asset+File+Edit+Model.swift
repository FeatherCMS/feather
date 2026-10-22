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

extension Asset.File.Edit {
    struct Model: Sendable {
        let id: String
        let title: String
        let altText: String
        let error: String?
    }
}
