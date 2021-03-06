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
                // gpsUpdateIdle
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateIdle');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [gpsUpdateIdle, 'gpsUpdateIdle'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'gpsUpdateIdle', '', '', '', gpsUpdateIdle ])}
                // dbVersion
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'dbVersion');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [dbVersion, 'dbVersion'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'dbVersion', '', '', '', dbVersion ])}
                // showHelptxt
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'showHelptxt');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [showHelptxt, 'showHelptxt'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'showHelptxt', '', '', '', showHelptxt ])}
                // iconsVisible
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'iconsVisible');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [iconsVisible, 'iconsVisible'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'iconsVisible', '', '', '', iconsVisible ])}
                // noteFontSize
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'noteFontSize');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [noteFontSize, 'noteFontSize'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'noteFontSize', '', '', '', noteFontSize ])}
                // projectDefault
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'projectDefault');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [projectDefault, 'projectDefault'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'projectDefault', '', projectDefault, '', '' ])}
                // locationBasedNote
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'locationBasedNote');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [locationBasedNote, 'locationBasedNote'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'locationBasedNote', '', '', '', locationBasedNote ])}
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
            // gpsUpdateIdle
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateIdle');
            if (rs.rows.length > 0) {gpsUpdateIdle = rs.rows.item(0).valint}
            else {}
            // dbVersion
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'dbVersion');
            if (rs.rows.length > 0) {dbVersion = rs.rows.item(0).valint}
            else {}
            // showHelptxt
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'showHelptxt');
            if (rs.rows.length > 0) {showHelptxt = rs.rows.item(0).valint}
            else {}
            // iconsVisible
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'iconsVisible');
            if (rs.rows.length > 0) {iconsVisible = rs.rows.item(0).valint}
            else {}
            // noteFontSize
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'noteFontSize');
            if (rs.rows.length > 0) {noteFontSize = rs.rows.item(0).valint}
            else {}
            // projectDefault
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'projectDefault');
            if (rs.rows.length > 0) {projectDefault = rs.rows.item(0).valte}
            else {}
            // locationBasedNote
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'locationBasedNote');
            if (rs.rows.length > 0) {locationBasedNote = rs.rows.item(0).valint}
            else {}
        }

    )
}
