import FeatherApplication

extension Submission.Detail {
    public enum Error: UseCaseError {
        case formNotFound
        case submissionNotFound
    }
}
