public import BlogApplication
import BlogInfrastructure
public import BlogModule
public import FeatherInfrastructure

extension UseCases {

    public func makeGetPublicSettings() -> DatabaseQueryExecutor<
        Settings.Get.Scope
    > {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Get.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
    }
}
