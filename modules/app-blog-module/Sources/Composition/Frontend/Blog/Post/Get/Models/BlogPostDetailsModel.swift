import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

struct BlogPostDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAssetId: String?
    let imageAsset: AdminMediaAssetReferenceModel?
    let metadata: AdminMetadataFormValue
    let authorIds: [String]
    let tagIds: [String]
}
