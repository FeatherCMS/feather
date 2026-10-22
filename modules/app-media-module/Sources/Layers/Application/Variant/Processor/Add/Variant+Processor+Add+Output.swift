public import FeatherApplication
public import MediaModule

extension Variant.Processor.Add {
    public struct Output: DTO {
        public let detail: Variant.Processor.Detail.Output

        public init(detail: Variant.Processor.Detail.Output) {
            self.detail = detail
        }
    }
}
