public import FeatherApplication
public import NewsModule

extension Article.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
