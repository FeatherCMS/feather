import NewsApplication
import NewsModule
import FeatherWebAdmin
import Foundation

extension NewsModule.Category.List {
    struct Model: Sendable {
        let items: [Item]
        let total: Int
        let page: Int
        let pageSize: Int

        struct Item: Sendable {
            let id: String
            let title: String
            let imageAsset: AdminMediaAsset?
            let metadata: AdminMetadataFormValue
            let availability: Availability

            enum Availability: String, Sendable {
                case draft
                case scheduled
                case live
                case expired
                case archived

                var label: String { rawValue.capitalized }

                var color: AdminChip.ColorName {
                    switch self {
                    case .draft: .yellow
                    case .scheduled: .blue
                    case .live: .green
                    case .expired: .orange
                    case .archived: .purple
                    }
                }

                static func resolve(_ value: String?) -> Self {
                    .init(rawValue: value ?? "draft") ?? .draft
                }
            }
        }
    }
}
