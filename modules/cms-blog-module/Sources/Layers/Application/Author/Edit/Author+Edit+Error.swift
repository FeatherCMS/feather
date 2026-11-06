public import BlogModule
public import FeatherApplication

extension Author.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
