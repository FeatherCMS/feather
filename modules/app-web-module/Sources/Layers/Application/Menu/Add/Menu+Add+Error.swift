public import FeatherApplication
public import WebModule

extension Menu.Add {
    public struct Error: UseCaseError {
        public let message: String
    }
}
