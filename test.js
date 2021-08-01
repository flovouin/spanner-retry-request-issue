const spanner = new (require("@google-cloud/spanner").Spanner)();

async function test() {
  const [instance] = await spanner.createInstance("local", {
    config: "emulator-config",
  });
  const [database] = await instance.createDatabase("test");
  const [table] = await database.createTable(
    "CREATE TABLE test (id STRING(10)) PRIMARY KEY (id)"
  );

  const startTime = new Date().getTime();

  const [snapshot] = await database.getSnapshot();
  try {
    await snapshot.read(table.name, {
      index: "nope",
    });
  } catch (error) {
    console.error(error.message);
  } finally {
    snapshot.end();
  }

  const delay = new Date().getTime() - startTime;
  console.log(`Took ${delay} ms`);
}

test();
