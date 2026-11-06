public import FeatherApplication
public import RedirectModule

extension Rule.Resolve {
    public enum Error: UseCaseError {
        case notFound
    }
}
