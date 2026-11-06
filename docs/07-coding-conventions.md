# Coding conventions

Use names that describe responsibility and follow the owning module's current source pattern.

## Namespaces and files

- Keep domain entities under entity namespaces, for example `Identity.Model` and `Identity.Repository.Interface`.
- Keep Application operations under the entity and operation, for example `Identity.Search.Input` and `Identity.Search.UseCase`.
- Put one primary declaration or one tightly related namespace extension family in each handwritten file. Name files after the declaration and namespace path.
- Avoid flat prefix-heavy types, redundant namespace wrappers, handwritten type aliases, and tuples. Generated files are exempt from handwritten layout rules.

## Layer vocabulary

| Layer | Typical names |
| --- | --- |
| Domain | `Model`, `Repository.Interface`, domain `Error` |
| Application | `Add`, `Edit`, `Detail`, `List`, `Search`, `Remove`; operation-owned `Input`, `Output`, `Scope`, `UseCase` |
| HTTP API | `Get`, `Post`, `Put`, `Patch`, `Delete`, `List`, `Query` |
| Infrastructure | `Table`, `Row`, `Repository.Database`, `Query.Database`, migration |

Use `List` for lightweight selection results and `Search` for structured application queries. The HTTP `Query` operation commonly adapts to an Application `Search` use case.

## Persistence names and boundaries

Use repositories for aggregate persistence and queries for read operations. Keep standard CRUD and schema work in Feather DBAL. Put custom SQL under Infrastructure `Database/AccessLayer`, only when DBAL cannot express it. See [module conventions](08-module-conventions.md) for detailed layout rules.
