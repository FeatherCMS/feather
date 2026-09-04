import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaFolderEditForm: Decodable {
    var name: String = ""

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
