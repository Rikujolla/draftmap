function loadImages() {

    var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

    db.transaction(
                function(tx) {
                    if (dbVersion < 3) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Imagestemp (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, widthscale REAL, heightscale REAL, UNIQUE(title,sourceim))');
                        tx.executeSql('DELETE FROM Imagestemp')
                        tx.executeSql('INSERT OR IGNORE INTO Imagestemp SELECT *,?,? FROM Images', [1.0, 1.0])
                        tx.executeSql('DROP TABLE Images')
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, widthscale REAL, heightscale REAL, UNIQUE(title,sourceim))');
                        tx.executeSql('INSERT OR IGNORE INTO Images SELECT * FROM Imagestemp')
                        dbVersion = 3;
                        console.log("DB version upgraded to ", dbVersion)
                        tx.executeSql('DROP TABLE Imagestemp')
                    }
                    else {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, widthscale REAL, heightscale REAL, UNIQUE(title,sourceim))');
                    }

                    var rs = tx.executeSql('SELECT * FROM Images')
                    imageInfo.clear()

                    for(var i = 0; i < rs.rows.length; i++) {
                        imageInfo.append({"title":rs.rows.item(i).title, "sourceim":rs.rows.item(i).sourceim, "latti":rs.rows.item(i).latti, "longi":rs.rows.item(i).longi, "stackheight":rs.rows.item(i).stackheight, "zlevel":rs.rows.item(i).zlevel, "rotat":rs.rows.item(i).rotat, "opacit":rs.rows.item(i).opacit, "widthscale":rs.rows.item(i).widthscale,"heightscale":rs.rows.item(i).heightscale})
                    }
                }
                )
}

/// The function adds an image to database
function addEditImage(j) {

    var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, widthscale REAL, heightscale REAL, UNIQUE(title,sourceim))');
                    tx.executeSql('INSERT OR REPLACE INTO Images VALUES (?,?,?,?,?,?,?,?,?,?)', [imageInfo.get(j).title, imageInfo.get(j).sourceim, imageInfo.get(j).latti, imageInfo.get(j).longi, imageInfo.get(j).stackheight, imageInfo.get(j).zlevel, imageInfo.get(j).rotat, imageInfo.get(j).opacit, imageInfo.get(j).widthscale, imageInfo.get(j).heightscale])
                }
                )
}

/// The function deletes an image from the database
function deleteImage(j) {

    var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, widthscale REAL, heightscale REAL, UNIQUE(title,sourceim))');
                    tx.executeSql('DELETE FROM Images WHERE title=? AND sourceim=?', [imageInfo.get(j).title, imageInfo.get(j).sourceim]);
                }
                )
}
