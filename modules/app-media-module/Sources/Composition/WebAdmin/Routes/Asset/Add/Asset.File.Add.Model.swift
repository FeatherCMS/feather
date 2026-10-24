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

extension Asset.File.Add {
    struct Model: Sendable {
        let parentId: String
        let fileName: String
        let `extension`: String
        let title: String
        let altText: String
        let data: String
        let error: String?
        let view: String
        let action: String
        let isPicker: Bool
        let selectedAsset: AdminMediaAsset?
    }
}
