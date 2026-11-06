public import MediaModule

extension Asset.File.View {
    public struct Variant: Sendable {
        public let name: String
        public let fileExtension: String
        public let url: String

        public init(name: String, fileExtension: String, url: String) {
            self.name = name
            self.fileExtension = fileExtension
            self.url = url
        }
    }
}
