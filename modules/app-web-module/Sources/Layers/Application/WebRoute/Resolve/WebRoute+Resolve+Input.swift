public import FeatherApplication

extension WebRoute.Resolve {
    public struct Input: DTO {
        public let slug: String

        public init(slug: String) {
            self.slug = slug
        }
    }
}
