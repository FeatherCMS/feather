public import FeatherApplication
public import BlogModule

extension AuthorLink.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
