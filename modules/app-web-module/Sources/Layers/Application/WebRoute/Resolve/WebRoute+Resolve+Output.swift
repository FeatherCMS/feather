public import FeatherApplication

extension WebRoute.Resolve {
    public struct Output: DTO {
        public let referenceType: String
        public let referenceID: String
        public let slug: String
        public let template: String

        public init(
            referenceType: String,
            referenceID: String,
            slug: String,
            template: String
        ) {
            self.referenceType = referenceType
            self.referenceID = referenceID
            self.slug = slug
            self.template = template
        }
    }
}
