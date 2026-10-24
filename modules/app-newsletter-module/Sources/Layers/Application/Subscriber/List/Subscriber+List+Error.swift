public import FeatherApplication
public import NewsletterModule

extension Subscriber.List {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
