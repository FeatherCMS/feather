public import FeatherApplication
public import ContactModule

extension Submission.Edit {
    public enum Error: UseCaseError {
        case formNotFound
        case submissionNotFound
    }
}
