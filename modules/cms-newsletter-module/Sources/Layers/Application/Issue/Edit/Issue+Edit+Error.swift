public import FeatherApplication
public import NewsletterModule

extension Issue.Edit {
    public enum Error: UseCaseError {
        case notFound
    }
}
