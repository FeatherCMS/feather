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

extension Asset.Folder.Add.Form {
    struct Input: Decodable {
        var parentId: String = ""
        var name: String = ""
        var view: String = "grid"

        var normalizedParentId: String? {
            parentId.whitespaceTrimmed.emptyToNil
        }

        var normalizedName: String {
            name.whitespaceTrimmed
        }
    }
}
