import carpenter/table
import gleam/erlang/process
import gleam/list
import gleam/string

@external(javascript, "./glorage_ffi.mjs", "run")
pub fn run(cb: fn() -> r) -> r {
  let assert Ok(storage) =
    get_table_name()
    |> table.build
    |> table.privacy(table.Private)
    |> table.write_concurrency(table.NoWriteConcurrency)
    |> table.read_concurrency(False)
    |> table.decentralized_counters(False)
    |> table.compression(False)
    |> table.set
  let resp = cb()
  storage |> table.drop
  resp
}

@external(javascript, "./glorage_ffi.mjs", "once")
pub fn once(fun: f, cb: fn() -> r) -> r {
  let assert Ok(storage) = get_table_name() |> table.ref
  case table.lookup(storage, fun) |> list.first {
    Ok(#(_, cached)) -> cached
    Error(Nil) -> {
      let resp = cb()
      table.insert(storage, [#(fun, resp)])
      resp
    }
  }
}

@external(javascript, "./glorage_ffi.mjs", "with1")
pub fn with(fun: fn(a) -> r, cb: fn(r) -> resp) -> resp {
  let assert Ok(storage) = get_table_name() |> table.ref
  let assert Ok(#(_, cached)) = table.lookup(storage, fun) |> list.first
  cached |> cb
}

@external(javascript, "./glorage_ffi.mjs", "getTableName")
fn get_table_name() -> String {
  "glorage " <> process.self() |> string.inspect
}
