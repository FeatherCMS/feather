public import FeatherApplication
public import ContactModule

extension Submission.List {
    public enum Error: UseCaseError {
        case formNotFound
    }
}
