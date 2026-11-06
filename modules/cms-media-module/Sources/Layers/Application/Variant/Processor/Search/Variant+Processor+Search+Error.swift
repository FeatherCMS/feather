public import FeatherApplication
public import MediaModule

extension Variant.Processor.Search {
    public enum Error: UseCaseError { case variantNotFound }
}
