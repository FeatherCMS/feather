import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaFolderAddForm: Decodable {
    var parentId: String = ""
    var name: String = ""
    var view: String = "grid"

    var normalizedParentId: String? {
        parentId.trimmingCharacters(in: .whitespacesAndNewlines).emptyToNil
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
