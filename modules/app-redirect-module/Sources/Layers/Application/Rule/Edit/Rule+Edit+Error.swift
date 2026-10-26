public import FeatherApplication
public import RedirectModule

extension Rule.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
