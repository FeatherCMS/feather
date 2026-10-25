public import FeatherApplication
public import MediaDomain
public import MediaModule

extension Variant.Processor.List {
    public struct Output: DTO {
        public let items: [Variant.Processor.Model]

        public init(items: [Variant.Processor.Model]) {
            self.items = items
        }
    }
}
