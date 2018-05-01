import Async
import Fluent
import Foundation

internal final class Country<D>: Model where D: QuerySupporting, D: IndexSupporting {
  /// See Model.Database
  typealias Database = D
  
  /// See Model.ID
  typealias ID = UUID
  
  /// See Model.name
  static var name: String { return "foo" }
  
  /// See Model.idKey
  static var idKey: IDKey { return \.id }
  
  /// Foo's identifier
  var id: UUID?
  
  /// Test string
  var name: String
  
  /// Test integer
  var continent: Int
  
  /// Create a new foo
  init(id: ID? = nil, name: String, continent: Int) {
    self.id = id
    self.name = name
    self.continent = continent
  }
}

internal struct CountryMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting {
  /// See Migration.database
  typealias Database = D
  
  /// See Migration.prepare
  static func prepare(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Country<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Country<Database>.id)
      try builder.field(for: \Country<Database>.name)
      try builder.field(for: \Country<Database>.continent)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
    }
  }
  
  /// See Migration.revert
  static func revert(on connection: Database.Connection) -> Future<Void> {
    return Database.delete(Foo<Database>.self, on: connection)
  }
}
