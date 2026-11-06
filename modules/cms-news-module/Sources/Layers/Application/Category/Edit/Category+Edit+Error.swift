public import FeatherApplication
public import NewsModule

extension Category.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
