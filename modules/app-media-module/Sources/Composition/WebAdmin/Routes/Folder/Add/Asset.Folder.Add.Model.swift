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

extension Asset.Folder.Add {
    struct Model: Sendable {
        let parentId: String?
        let name: String
        let view: String
        let error: String?
    }
}
