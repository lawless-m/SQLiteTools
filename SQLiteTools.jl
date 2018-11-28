module SQLiteTools

using SQLite
using DataArrays

inserts = Dict()
updates = Dict()

export bind!, exebind!, truncate!, column_n, table_by, select_all, insert!, missInt, int2date, int2time

missInt(v) = typeof(v) == Missings.Missing ? 0 : convert(Int, v)
int2date(dv) = Date(Dates.UTD(missInt(dv)))
int2time(dv) = DateTime(Dates.UTM(missInt(dv)))
insert!(db, name, sql) = inserts[name] = SQLite.Stmt(db, sql)

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


bind!(ins::String, coln::Int, val) = SQLite.bind!(inserts[ins], coln, val)

bind!(ins::String, vals::Vector, cols::Vector) = bind!(inserts[ins], vals, cols)

exebind!(ins::String, vals::Vector, cols::Vector) = exebind!(inserts[ins], vals, cols)

exebind!(ins::String, vals::Vector) = exebind!(inserts[ins], vals)


end

