import { AsyncLocalStorage } from "node:async_hooks";

const als = new AsyncLocalStorage();

export const run = (cb) => {
  return als.run(new Map(), cb);
};

export const once = (fun, cb) => {
  const storage = getStorage();
  if (storage.has(fun)) {
    return storage.get(fun);
  }
  const resp = cb();
  storage.set(fun, resp);
  return resp;
};

export const with1 = (fun, cb) => {
  const storage = getStorage();
  if (!storage.has(fun)) {
    throw new Error("Cached value not exists");
  }
  return cb(storage.get(fun));
};

export const getTableName = () => "";

const getStorage = () => {
  const storage = als.getStore();
  if (storage == null) {
    throw new Error(
      "Thread local storage not initialized, please use run before"
    );
  }
  return storage;
};
