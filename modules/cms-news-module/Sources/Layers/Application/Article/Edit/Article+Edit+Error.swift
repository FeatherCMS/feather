public import FeatherApplication
public import NewsModule

extension Article.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
