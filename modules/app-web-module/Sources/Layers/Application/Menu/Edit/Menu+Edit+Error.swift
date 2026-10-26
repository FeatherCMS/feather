public import FeatherApplication
public import WebModule

extension Menu.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
