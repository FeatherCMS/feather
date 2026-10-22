public import FeatherApplication
import NewsletterModule

extension Campaign.Detail {
    public struct Input: DTO {
        enum Identifier: Sendable {
            case id(String)
            case key(String)
        }

        let identifier: Identifier

        public init(key: String) {
            identifier = .key(key)
        }

        public init(id: String) {
            identifier = .id(id)
        }
    }
}
