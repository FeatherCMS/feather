import FeatherModuleKit
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

extension Asset.Folder.Edit.Form {
    struct Input: Decodable {
        var name: String = ""

        var normalizedName: String {
            name.whitespaceTrimmed
        }
    }
}
