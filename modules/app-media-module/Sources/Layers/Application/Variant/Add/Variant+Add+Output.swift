public import FeatherApplication
public import MediaModule

extension Variant.Add {
    public struct Output: DTO {
        public let detail: Variant.Detail.Output

        public init(detail: Variant.Detail.Output) {
            self.detail = detail
        }
    }
}
