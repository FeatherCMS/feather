import Foundation

struct AdminMediaAssetReferenceModel: Codable, Sendable, Equatable, Hashable {
    let id: String
    let storageKey: String
    let baseName: String
    let type: String
    let title: String?
    let altText: String?
    let status: String
}
