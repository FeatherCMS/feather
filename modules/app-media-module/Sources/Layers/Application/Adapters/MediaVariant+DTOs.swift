import MediaDomain

extension MediaVariant {
    public var asVariantListItem: MediaVariantList.Item {
        .init(id: id, key: key, name: name, isRequired: isRequired, isActive: isActive)
    }
}

extension MediaVariantProcessor {
    public var asVariantProcessorListItem: MediaVariantProcessorList.Item {
        .init(id: id, variantId: variantId, name: name, matchExtensions: matchExtensions, commandTemplate: commandTemplate, isActive: isActive)
    }
}
