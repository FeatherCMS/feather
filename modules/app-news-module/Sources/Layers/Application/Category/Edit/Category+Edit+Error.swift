public import FeatherApplication
public import NewsModule

extension Category.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
