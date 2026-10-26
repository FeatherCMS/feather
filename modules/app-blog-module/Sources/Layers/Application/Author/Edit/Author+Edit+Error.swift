public import FeatherApplication
public import BlogModule

extension Author.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
