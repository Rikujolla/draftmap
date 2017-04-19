    function saveSettings() {

        var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                // gpsUpdateRate
                var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateRate');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [gpsUpdateRate, 'gpsUpdateRate'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'gpsUpdateRate', '', '', '', gpsUpdateRate ])}
                // useLocation
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'useLocation');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [useLocation, 'useLocation'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'useLocation', '', '', '', useLocation ])}
                // folder
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'folder');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [folder, 'folder'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'folder', '', folder, '', '' ])}
            }
        )
    }

function loadSettings() {

    var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // gpsUpdateRate
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateRate');
            if (rs.rows.length > 0) {gpsUpdateRate = rs.rows.item(0).valint}
            else {}
            // useLocation
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'useLocation');
            if (rs.rows.length > 0) {useLocation = rs.rows.item(0).valint}
            else {}
            // folder
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'folder');
            if (rs.rows.length > 0) {folder = rs.rows.item(0).valte}
            else {}
        }

    )
}
