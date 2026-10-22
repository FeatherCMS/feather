public import MediaDomain
public import MediaModule

extension Variant.Model {
    public var asVariantSearchItem: Variant.Search.Output.Item {
        .init(
            id: id,
            key: key,
            name: name,
            isRequired: isRequired,
            isActive: isActive
        )
    }
}

extension Variant.Processor.Model {
    public var asDetail: Variant.Processor.Detail.Output {
        .init(
            id: id,
            variantId: variantId,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public var asVariantProcessorSearchItem:
        Variant.Processor.Search.Output.Item
    {
        .init(
            id: id,
            variantId: variantId,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive
        )
    }
}
