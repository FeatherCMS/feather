public import FeatherApplication
public import MediaModule

extension Asset.Folder.Add {
    public struct Output: DTO {
        public let detail: Asset.Folder.Detail.Output

        public init(detail: Asset.Folder.Detail.Output) {
            self.detail = detail
        }
    }
}
