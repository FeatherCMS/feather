import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.View {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
    }
}
