public import BlogModule
public import FeatherApplication

extension AuthorLink.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
