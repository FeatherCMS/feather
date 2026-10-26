public import FeatherApplication
public import BlogModule

extension AuthorLink.Detail {
    public struct Error: UseCaseError {
        public let message: String
    }
}
