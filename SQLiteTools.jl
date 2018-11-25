module SQLiteTools

using SQLite

export bind!, exebind!, truncate!, column_n, table_by, select_all

bind!(st::SQLite.Stmt, vals::Vector, cols::Vector) = foreach((n)->SQLite.bind!(st, cols[n], vals[n]), 1:length(cols))

bind!(st::SQLite.Stmt, vals::Vector) = foreach((n)->SQLite.bind!(st, n, vals[n]), 1:length(vals))

function exebind!(st::SQLite.Stmt, vals::Vector, cols::Vector)
	bind!(st, vals, cols)
	SQLite.execute!(st)
end

function exebind!(st::SQLite.Stmt, vals::Vector)
	bind!(st, vals)
	SQLite.execute!(st)
end

truncate!(db, table::String) = SQLite.query(db, "DELETE FROM $table")

column_n(db, table::String, n::Integer) = SQLite.query(db, "SELECT * from $table")[1:end, n]

table_by(db, table::String, orderby::String) = SQLite.query(db, "select * from $table Order By $orderby")	


end

