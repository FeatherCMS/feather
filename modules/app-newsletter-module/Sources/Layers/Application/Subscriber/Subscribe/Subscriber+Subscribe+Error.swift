public import FeatherApplication
public import NewsletterModule

extension Subscriber.Subscribe {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
