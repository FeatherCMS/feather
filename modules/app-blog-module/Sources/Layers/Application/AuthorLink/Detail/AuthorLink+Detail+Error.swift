public import BlogModule
public import FeatherApplication

extension AuthorLink.Detail {
    public struct Error: UseCaseError {
        public let message: String
    }
}
