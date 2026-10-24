public import FeatherApplication
public import WebModule

extension Menu.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
