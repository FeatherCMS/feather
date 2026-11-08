import BlogModule
import FeatherWebAdmin
import Foundation

extension Post.List {
    struct Item: Sendable {
        let id: String
        let title: String
        let coverImage: CoverImage?
        let metadata: AdminMetadataFormValue
        let availability: Availability

        struct CoverImage: Sendable {
            let url: String
            let altText: String?
            let variants: [Variant]

            struct Variant: Sendable {
                let key: String
                let url: String
            }
        }

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
