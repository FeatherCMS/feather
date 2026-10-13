import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaFolderAddForm: Decodable {
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
