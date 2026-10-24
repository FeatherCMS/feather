public import FeatherApplication
public import BlogModule

extension AuthorLink.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
