public import ContactModule
public import FeatherApplication

extension Submission.Edit {
    public enum Error: UseCaseError {
        case formNotFound
        case submissionNotFound
    }
}
