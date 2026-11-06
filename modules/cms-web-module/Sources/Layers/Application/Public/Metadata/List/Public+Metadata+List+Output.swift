public import FeatherApplication

extension Public.Metadata.List {
    public struct Output: DTO {
        public let slugs: [String]

        public init(slugs: [String]) {
            self.slugs = slugs
        }
    }
}
