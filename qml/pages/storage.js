.import QtQuick.LocalStorage 2.0 as Sql
//storage.js
// First, let's create a short helper function to get the database connection
function getDatabase() {
     return Sql.LocalStorage.openDatabaseSync("converter", "1.0", "StorageDatabase", 100000);        //TODO: Make up a decent name for the app
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS units(name TEXT UNIQUE, quantity TEXT, value FLOAT)');
      });
}

// This function is used to write a unit into the database
function setUnit(unit, quantity, value) {
   // name: string representing the unit name (eg: “meter”)
   // value: string representing the value of the unit in relation to SI unit (eg: “1.0”)
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO units VALUES (?,?,?);', [unit, quantity, value]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}
// This function is used to retrieve the value for a unit from the database
function getValue(unit) {
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT value FROM units WHERE name=?;', [unit]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).value;
     } else {
         res = "Unknown";
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}

// This function is used to retrieve all quantities from the database
function getQuantities() {
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT DISTINCT quantity FROM units;');
     if (rs.rows.length > 0) {
          res = rs;
     } else {
         res = "Unknown";
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}

// This function retrieves all units from the database
function getUnits(quantity) {
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
       var rs = tx.executeSql('SELECT name FROM units WHERE quantity=?;', [quantity]);
     if (rs.rows.length > 0) {
          res = rs;
     } else {
         res = "Unknown";
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}

// This function drops the units table
function dropTable() {
   var db = getDatabase();
   db.transaction(function(tx) {
     tx.executeSql('DROP TABLE IF EXISTS units');
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
}


