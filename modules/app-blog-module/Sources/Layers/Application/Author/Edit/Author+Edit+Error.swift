public import FeatherApplication
public import BlogModule

extension Author.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
