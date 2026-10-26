public import FeatherApplication
public import BlogModule

extension AuthorLink.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
