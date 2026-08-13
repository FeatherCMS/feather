extension String {
    public func prefixedSlug(
        with prefix: String
    ) -> String {
        let prefixParts =
            prefix
            .split(separator: "/")
            .map(String.init)
            .map { $0.slugify() }
            .filter { !$0.isEmpty }

        let value = slugify()
        return String(
            (prefixParts + [value]).joined(separator: "/").prefix(254)
        )
    }
}
