import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.View {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
        let authorIds: [String]
        let tagIds: [String]
    }
}
