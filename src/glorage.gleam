import carpenter/table
import gleam/erlang/process
import gleam/list
import gleam/string

pub fn run(cb: fn() -> r) {
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

pub fn get(fun: fn(a) -> r) -> r {
  let assert Ok(storage) = get_table_name() |> table.ref
  let assert Ok(#(_, cached)) = table.lookup(storage, fun) |> list.first
  cached
}

fn get_table_name() {
  "glorage " <> process.self() |> string.inspect
}
