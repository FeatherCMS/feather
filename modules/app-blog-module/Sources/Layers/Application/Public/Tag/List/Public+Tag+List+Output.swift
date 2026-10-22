public import FeatherApplication

extension Public.Tag.List {
    public struct Output: DTO {
        public let items: [Public.Tag.Summary.Output]

        public init(items: [Public.Tag.Summary.Output]) {
            self.items = items
        }
    }
}
