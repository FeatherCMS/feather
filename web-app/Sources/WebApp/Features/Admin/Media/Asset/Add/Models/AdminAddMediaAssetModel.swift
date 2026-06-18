import Foundation

struct AdminAddMediaAssetModel: Sendable {
    let parentId: String
    let fileName: String
    let type: String
    let title: String
    let altText: String
    let data: String
    let error: String?
    let view: String
    let action: String
    let isPicker: Bool
    let selectedAsset: AdminMediaAssetReferenceModel?
}
