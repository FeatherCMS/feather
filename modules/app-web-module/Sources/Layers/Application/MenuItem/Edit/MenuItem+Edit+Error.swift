public import FeatherApplication
public import WebModule

extension MenuItem.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
