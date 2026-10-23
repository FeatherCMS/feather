public import FeatherApplication
public import NewsletterModule

extension Delivery.List {
    public enum Error: UseCaseError {
        case notFound
    }
}
