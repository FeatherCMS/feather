import FeatherAdmin
import FeatherValidation
import FeatherContracts
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaFolderEditForm: Decodable {
    var name: String = ""

    var normalizedName: String {
        name.whitespaceTrimmed
    }
}
