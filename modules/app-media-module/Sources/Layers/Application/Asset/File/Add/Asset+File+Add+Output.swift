public import FeatherApplication
public import MediaModule

extension Asset.File.Add {
    public struct Output: DTO {
        public let detail: Asset.File.Detail.Output

        public init(detail: Asset.File.Detail.Output) {
            self.detail = detail
        }
    }
}
