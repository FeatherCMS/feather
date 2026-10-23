public import FeatherApplication
public import ContactModule

extension Submission.Detail {
    public enum Error: UseCaseError {
        case formNotFound
        case submissionNotFound
    }
}
