import Foundation

struct WebPageDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAssetId: String?
    let imageAsset: AdminMediaAssetReferenceModel?
    let metadata: AdminMetadataFormValue
}
