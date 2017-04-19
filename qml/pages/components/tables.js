function loadImages() {

    var db = LocalStorage.openDatabaseSync("DraftmapDB", "1.0", "Draft map database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight INTEGER, zlevel REAL, rotat REAL, opacit REAL, UNIQUE(title,sourceim))');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight REAL, zlevel REAL, rotat REAL, opacit REAL, UNIQUE(title,sourceim))');


                    var rs = tx.executeSql('SELECT * FROM Images')
                    imageInfo.clear()

                    for(var i = 0; i < rs.rows.length; i++) {
                        imageInfo.append({"title":rs.rows.item(i).title, "sourceim":rs.rows.item(i).sourceim, "latti":rs.rows.item(i).latti, "longi":rs.rows.item(i).longi, "stackheight":rs.rows.item(i).stackheight, "zlevel":rs.rows.item(i).zlevel, "rotat":rs.rows.item(i).rotat, "opacit":rs.rows.item(i).opacit})
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Images (title TEXT, sourceim TEXT, latti REAL, longi REAL, stackheight REAL, zlevel REAL, rotat REAL, opacit REAL, UNIQUE(title,sourceim))');

                    tx.executeSql('INSERT OR REPLACE INTO Images VALUES (?,?,?,?,?,?,?,?)', [imageInfo.get(j).title, imageInfo.get(j).sourceim, imageInfo.get(j).latti, imageInfo.get(j).longi, imageInfo.get(j).stackheight, imageInfo.get(j).zlevel, imageInfo.get(j).rotat, imageInfo.get(j).opacit])
                }
                )
    //loadImages()
}

//////// Function readData() reads data to map
function readData() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');

                    var rs = tx.executeSql('SELECT *, max(lamlocaltime), strftime(?,?)-strftime(?,lamlocaltime) AS age FROM Valuetable INNER JOIN Subloc ON Valuetable.valamid = Subloc.lamid GROUP BY Valuetable.valamid',['%s', 'now', '%s'])
                    //rs = tx.executeSql('SELECT * FROM Locations INNER JOIN Priorities ON Locations.theplace = Priorities.theplace INNER JOIN Cellinfo ON Priorities.theplace = Cellinfo.theplace WHERE Priorities.cell = ? AND Cellinfo.thecelli = ? ORDER BY tolerlong ASC LIMIT 1', ['1',currentCell]);

                    lamPoints.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        //console.log(rs.rows.item(i).age)
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 0, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat1, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong1, "veloc":rs.rows.item(i).averagespeed1, "age":rs.rows.item(i).age, "cars":rs.rows.item(i).trafficvolume1})
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 1, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat2, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong2, "veloc":rs.rows.item(i).averagespeed2, "age":rs.rows.item(i).age, "cars":rs.rows.item(i).trafficvolume2})
                        if (rs.rows.item(i).lamid == coverLam) {
                            if (coverPair == 0){
                                speedLAM = rs.rows.item(i).averagespeed1
                                carsLAM = rs.rows.item(i).trafficvolume1
                            }
                            else {
                                speedLAM = rs.rows.item(i).averagespeed2
                                carsLAM = rs.rows.item(i).trafficvolume2
                            }
                        }

                    }
                }
                )
}

/// The function drawSpeed() reads data to lists to plot curves
function drawSpeed(daysbf) {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {

                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historystable (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Theday (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('DROP TABLE Theday')
                    //tx.executeSql('DELETE FROM Valuetable')



                    var time = new Date().getTime()
                    //var offset = new Date().getTimezoneOffset()
                    var offset = new Date(time-daysbf*24*60*60*1000).getTimezoneOffset()
                    //console.log("ovset2", daysbf, offset)
                    var zeero = new Date(time + offset*60*1000 - time%(24*60*60*1000)) //RLAH
                    switch (daysbf){
                    case 0:
                        var dbf = "now"
                        var dbfm = "-" + daysbf + " days"; // As above but minus
                        var dbfminus = "-" + (daysbf+1) + " days"; // Making string for sqlquery days before minus 1 as negative
                        var dbfminusmin = "-" + (daysbf+2) + " days"; // Making string for sqlquery days before minus 2 as negative
                        var dbfplus = "+" + 1 + " days"; // Making string for sqlquery daysbf plus one as negative
                        break;
                    default:
                        dbf = "+" + daysbf + " days"; // Making string for sqlquery days before
                        dbfm = "-" + daysbf + " days"; // As above but minus
                        dbfminus = "-" + (daysbf+1) + " days"; // Making string for sqlquery days before minus 1 as negative
                        dbfminusmin = "-" + (daysbf+2) + " days"; // Making string for sqlquery days before minus 2 as negative
                        dbfplus = "-" + (daysbf-1) + " days"; // Making string for sqlquery daysbf plus one as negative
                        //console.log (dbf, dbfminus, dbfplus);
                    }
                    var hfillin = 0; //Fill-indata for history
                    var tfillin = 0; //Fill-indata for the day
                    //var tquality = 0; // The day data quality, the mount of the measured data divided by maximum
                    if (!cumulativeView || speedView) {
                        var rs = tx.executeSql('SELECT * FROM Valuetable WHERE valamid =? AND date(lamlocaltime,?) > date(?,?,?) AND date(lamlocaltime,?) < date(?,?,?)', [lammiSelected, 'localtime', 'now',dbfminus,'localtime','localtime', 'now',dbfplus, 'localtime'])
                    }
                    if (daysbf == 0) {
                        var rw = tx.executeSql('SELECT strftime(?,?,?)AS wdaynow', ['%w', 'now', 'localtime'])
                    }
                    else {
                        rw = tx.executeSql('SELECT strftime(?,?,?,?)AS wdaynow', ['%w', 'now', dbfm, 'localtime'])
                    }
                    //console.log('The day', rw.rows.item(0).wdaynow)

                    if (cumulativeView && !speedView) { // need to remove extra lines for cumulative view, not needed for density view, slows the software??
                        console.log("dbVersion", dbVersion)
                        if (dbVersion < 10){
                            tx.executeSql('DELETE FROM Valuetable WHERE valamid=? AND (strftime(?,lamlocaltime)) >= ? AND rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)', [lammiSelected, '%s', doublesAway])
                        }
                        tx.executeSql('CREATE TABLE Theday AS SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE valamid=? AND (strftime(?,?) - strftime(?,lamlocaltime))< ? AND (strftime(?,?) - strftime(?,lamlocaltime))> ? AND wday = ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,lammiSelected,'%s', 'now', '%s', 86400*(daysbf+1), '%s', 'now', '%s', 86400*(daysbf-1),rw.rows.item(0).wdaynow])
                        rs = tx.executeSql('SELECT * FROM Theday')
                        var rss = tx.executeSql('SELECT sum(nhist) AS thesum, max(htime) AS themax FROM Theday');
                        thedayQuality = 300*100*rss.rows.item(0).thesum/rss.rows.item(0).themax;
                        //console.log(rss.rows.item(0).thesum, rss.rows.item(0).themax, thedayQuality);
                        /*for(var j = 0; j < rs.rows.length; j++) {
                            console.log("The day", rs.rows.item(j).valamid, rs.rows.item(j).wday, rs.rows.item(j).htime, rs.rows.item(j).mtr1, rs.rows.item(j).nhist)
                        }*/
                        if (rs.rows.length > 0) {
                        tx.executeSql('INSERT INTO Theday SELECT * FROM Historystable WHERE valamid=? AND wday=? AND htime < ?', [lammiSelected, rw.rows.item(0).wdaynow, rs.rows.item(rs.rows.length-1).htime])
                        }
                        //var rs = tx.executeSql('SELECT * from Theday, Historystable WHERE Historystable.valamid=? AND Historystable.wday=?', [lammiSelected, rw.rows.item(0).wdaynow])
                        //rs = tx.executeSql('SELECT * FROM Theday')
                        /*for(j = 0; j < rs.rows.length; j++) {
                            console.log("History joint", rs.rows.item(j).valamid, rs.rows.item(j).wday, rs.rows.item(j).htime, rs.rows.item(j).mtr1, rs.rows.item(j).nhist)
                        }*/
                        tx.executeSql('DELETE FROM Theday WHERE rowid NOT IN (SELECT min(rowid) FROM Theday GROUP BY htime)')
                        rs = tx.executeSql('SELECT *, datetime(htime+?,?,?) AS hhtime FROM Theday ORDER BY htime ASC', [(time + offset*60*1000 - time%(24*60*60*1000)- daysbf*24*60*60*1000)/1000, 'unixepoch', 'localtime'])
                        /*for(j = 0; j < rs.rows.length; j++) {
                            console.log("Reduced", rs.rows.item(j).valamid, rs.rows.item(j).wday, rs.rows.item(j).htime, rs.rows.item(j).hhtime, rs.rows.item(j).mtr1, rs.rows.item(j).nhist)
                        }*/
                    }

                    var ry = tx.executeSql('SELECT *, datetime(lamlocaltime,?,?) AS lamtime FROM Valuetable WHERE valamid =? AND date(lamlocaltime,?) > date(?,?,?) AND date(lamlocaltime,?) < date(?,?,?)', ['+1 day','localtime', lammiSelected, 'localtime', 'now',dbfminusmin,'localtime','localtime', 'now',dbfm, 'localtime'])
                    var rt = tx.executeSql('SELECT *, datetime(htime+?,?,?) AS hhtime FROM Historystable WHERE valamid=? AND wday=?', [(time + offset*60*1000 - time%(24*60*60*1000)- daysbf*24*60*60*1000)/1000, 'unixepoch', 'localtime', lammiSelected, rw.rows.item(0).wdaynow])



                    dataList.clear();
                    var tempSumTraf1 = 0;
                    var tempSumTraf1Yest = 0;
                    var tempSumTraf1Hist = 0;
                    for(var i = 0; i < rs.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed1})
                            }
                            else {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                if (!cumulativeView) {
                                    dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume1})
                                }
                                else {
                                    // Creating fill-in data if there are not all ten minutes points in the day data by adding mean values between
                                    if (i>0 && (rs.rows.item(i).htime - rs.rows.item(i-1).htime >600)) {
                                        tfillin = ((rs.rows.item(i).htime - rs.rows.item(i-1).htime)/600 -1) * (rs.rows.item(i-1).mtr1/rs.rows.item(i-1).nhist + rs.rows.item(i).mtr1/rs.rows.item(i).nhist)/2
                                        console.log("DayFilling", hfillin, rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr1/rs.rows.item(i).nhist, tempSumTraf1Hist)
                                    }
                                    else if (i==0 && rs.rows.item(i).htime > 0) {
                                        // Filling mean of the missing data assuming the first value to be zero
                                        tfillin = ((rs.rows.item(i).htime)/600) * (rs.rows.item(i).mtr1/rs.rows.item(i).nhist)/2
                                        console.log("DayFilling0", hfillin, rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr1/rs.rows.item(i).nhist, tempSumTraf1Hist)

                                    }
                                    tempSumTraf1 = tempSumTraf1 + rs.rows.item(i).mtr1/rs.rows.item(i).nhist + tfillin;
                                    dataList.append({"timestamp":rs.rows.item(i).hhtime, "speed":tempSumTraf1})
                                    tfillin = 0;
                                    //console.log(rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr1/rs.rows.item(i).nhist, tempSumTraf1)
                                }
                            }
                            else {
                                if (!cumulativeView) {
                                    dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume2})
                                }
                                else {
                                    // Creating fill-in data if there are not all ten minutes points in the day data by adding mean values between
                                    if (i>0 && (rs.rows.item(i).htime - rs.rows.item(i-1).htime >600)) {
                                        tfillin = ((rs.rows.item(i).htime - rs.rows.item(i-1).htime)/600 -1) * (rs.rows.item(i-1).mtr2/rs.rows.item(i-1).nhist + rs.rows.item(i).mtr2/rs.rows.item(i).nhist)/2
                                        console.log("DayFilling", hfillin, rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr2/rs.rows.item(i).nhist, tempSumTraf1Hist)
                                    }
                                    else if (i==0 && rs.rows.item(i).htime > 0) {
                                        // Filling mean of the missing data assuming the first value to be zero
                                        tfillin = ((rs.rows.item(i).htime)/600) * (rs.rows.item(i).mtr2/rs.rows.item(i).nhist)/2
                                        console.log("DayFilling0", hfillin, rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr2/rs.rows.item(i).nhist, tempSumTraf1Hist)

                                    }
                                    tempSumTraf1 = tempSumTraf1 + rs.rows.item(i).mtr2/rs.rows.item(i).nhist + tfillin;
                                    dataList.append({"timestamp":rs.rows.item(i).hhtime, "speed":tempSumTraf1})
                                    tfillin = 0;
                                    //console.log(rs.rows.item(i).htime, rs.rows.item(i).hhtime, rs.rows.item(i).mtr2/rs.rows.item(i).nhist, tempSumTraf1)
                                }

                            }
                        }
                    }

                    dataYesterday.clear();
                    for(i = 0; i < ry.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed1})
                            }
                            else {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                if (!cumulativeView) {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume1})
                                }
                                else {
                                    // Maybe some day this works
                                    //tempSumTraf1Yest = tempSumTraf1Yest + ry.rows.item(i).trafficvolume1
                                    //dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":tempSumTraf1Yest})
                                }
                            }
                            else {
                                if (!cumulativeView) {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume2})
                                }
                                else {
                                    // Maybe some day this works
                                }
                            }
                        }
                    }

                    dataHistory.clear();
                    //console.log("History", rt.rows.length);
                    for(i = 0; i < rt.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).msp1/rt.rows.item(i).nhist})
                            }
                            else {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).msp2/rt.rows.item(i).nhist})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                if (!cumulativeView) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).mtr1/rt.rows.item(i).nhist})
                                }
                                else {
                                    // Creating fill-in data if there are not all ten minutes points in history by adding mean values between
                                    if (i>0 && (rt.rows.item(i).htime - rt.rows.item(i-1).htime >600)) {
                                        hfillin = ((rt.rows.item(i).htime - rt.rows.item(i-1).htime)/600 -1) * (rt.rows.item(i-1).mtr1/rt.rows.item(i-1).nhist + rt.rows.item(i).mtr1/rt.rows.item(i).nhist)/2
                                        console.log("HistoryFilling", hfillin, rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr1/rt.rows.item(i).nhist, tempSumTraf1Hist)
                                    }
                                    else if (i==0 && rt.rows.item(i).htime > 0) {
                                        // Filling mean of the missing data assuming the first value to be zero
                                        hfillin = ((rt.rows.item(i).htime)/600) * (rt.rows.item(i).mtr1/rt.rows.item(i).nhist)/2
                                        console.log("HistoryFilling0", hfillin, rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr1/rt.rows.item(i).nhist, tempSumTraf1Hist)

                                    }

                                    tempSumTraf1Hist = tempSumTraf1Hist + rt.rows.item(i).mtr1/rt.rows.item(i).nhist + hfillin;
                                    dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":tempSumTraf1Hist})
                                    hfillin = 0;
                                    //console.log(rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr1/rt.rows.item(i).nhist, tempSumTraf1Hist)
                                }
                            }
                            else {
                                if (!cumulativeView) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).mtr2/rt.rows.item(i).nhist})
                                }
                                else {
                                    // Creating fill-in data if there are not all ten minutes points in history by adding mean values between
                                    if (i>0 && (rt.rows.item(i).htime - rt.rows.item(i-1).htime >600)) {
                                        hfillin = ((rt.rows.item(i).htime - rt.rows.item(i-1).htime)/600 -1) * (rt.rows.item(i-1).mtr2/rt.rows.item(i-1).nhist + rt.rows.item(i).mtr2/rt.rows.item(i).nhist)/2
                                        console.log("HistoryFilling", hfillin, rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr2/rt.rows.item(i).nhist, tempSumTraf1Hist)
                                    }
                                    else if (i==0 && rt.rows.item(i).htime > 0) {
                                        // Filling mean of the missing data assuming the first value to be zero
                                        hfillin = ((rt.rows.item(i).htime)/600) * (rt.rows.item(i).mtr2/rt.rows.item(i).nhist)/2
                                        console.log("HistoryFilling0", hfillin, rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr2/rt.rows.item(i).nhist, tempSumTraf1Hist)

                                    }

                                    tempSumTraf1Hist = tempSumTraf1Hist + rt.rows.item(i).mtr2/rt.rows.item(i).nhist + hfillin;
                                    dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":tempSumTraf1Hist})
                                    hfillin = 0;
                                    //console.log(rt.rows.item(i).htime, rt.rows.item(i).hhtime, rt.rows.item(i).mtr2/rt.rows.item(i).nhist, tempSumTraf1Hist)
                                }

                            }
                        }
                    }
                }
                )
}

/// Function maintainDb() removes double lines from Valuetable and calls makeHistory() function
function maintainDb() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);
    //db.vacuum()
    db.transaction(
                function(tx) {
                    if (dbVersion < 10) {
                        // Record time when doubles removed, makes chart creation faster
                        var rs = tx.executeSql('SELECT strftime(?,?) AS mod', ['%s', 'now'])
                        doublesAway = rs.rows.item(0).mod;
                        // Create the table, if not existing
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                        tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')
                    }
                }
                )
    makeHistory();
}

/// Function subsetLocation() selects points to view to have values. Makes display response better
function subsetLocation() {
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('DROP TABLE Subloc')
                    tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.12 and abs(longi-?) < 0.12', [currentLat, currentLong])

                    //var rs = tx.executeSql('SELECT * FROM Subloc')
                    //console.log("Subtable table length ", rs.rows.length)
                }
                )
}

/// Function makeHistory() permanently attaches daily values to the history curve.
function makeHistory() {
    //console.log("Make history")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS History (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historystable (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historytemp (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('DROP TABLE History')
                    tx.executeSql('DROP TABLE Historytemp')
                    if (dbVersion < 10) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetabletemp (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                        tx.executeSql('DELETE FROM Valuetabletemp')
                        tx.executeSql('INSERT OR IGNORE INTO Valuetabletemp SELECT * FROM Valuetable')
                        tx.executeSql('DROP TABLE Valuetable')
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                        tx.executeSql('INSERT OR IGNORE INTO Valuetable SELECT * FROM Valuetabletemp')
                        dbVersion = 10;
                        console.log("DB version upgraded to ", dbVersion)
                        tx.executeSql('DROP TABLE Valuetabletemp')
                    }

                    //tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime) AS wday, ((strftime(?,lamlocaltime)%?)-(strftime(?,lamlocaltime)%?)%?) AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', '%s', 86400, '%s', 86400, 600, '%s', 'now', '%s', 702000])
                    var testing = 0
                    if (testing==1) {
                        console.log("Testing")
                        /* Testing section
                    var rx = tx.executeSql('SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 9000])

                    for (var i = 0; i < rx.rows.length; i++) {
                        if (rx.rows.item(i).valamid == 901) {console.log(rx.rows.item(i).htime)}
                    }*/
                        tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 702000])


                    }
                    else {
                        tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 702000])
                        tx.executeSql('INSERT INTO Historystable SELECT * FROM History')
                        tx.executeSql('CREATE TABLE Historytemp AS SELECT valamid, wday, htime, total(mtr1) AS mtr1, total(mtr2) AS mtr2, total(msp1) AS msp1, total(msp2) AS msp2, sum(nhist) AS nhist FROM Historystable GROUP BY valamid, htime, wday')
                        tx.executeSql('DELETE FROM Historystable')
                        tx.executeSql('INSERT INTO Historystable SELECT * FROM Historytemp')
                        tx.executeSql('DELETE FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ?', ['%s', 'now', '%s', 702000])
                    }

                }
                )
}

/// Function searchLAM() finds the lam specified by lam number
function searchLAM(lam) {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    //tx.executeSql('DROP TABLE Subloc')
                    //tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.12 and abs(longi-?) < 0.12', [currentLat, currentLong])
                    var rs = tx.executeSql('SELECT * FROM Location WHERE lamid = ?', lam)

                    //var rs = tx.executeSql('SELECT * FROM Subloc')
                    //console.log("Subtable table length ", rs.rows.length)
                    searchLatti = rs.rows.item(0).latti
                    searchLongi = rs.rows.item(0).longi
                }
                )
    searchDone = true
}

/// Function removeZeros() removes zero values from data
function removeZeros() {
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);
    //db.vacuum()
    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER, UNIQUE(valamid,lamlocaltime))');
                    if (dbVersion < 10) {
                        // Record time when doubles removed, makes chart creation faster
                        var rs = tx.executeSql('SELECT strftime(?,?) AS mod', ['%s', 'now'])
                        doublesAway = rs.rows.item(0).mod;
                        // Delete double values
                        tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')
                        // Delete zeros between 7 and 17 localtime, (is the behaviour same in all zones??
                        //var rs = tx.executeSql('SELECT * FROM Valuetable WHERE ((strftime(?,lamlocaltime,?))%?) > ? AND ((strftime(?,lamlocaltime,?))%?) < ? AND trafficvolume1 = ? AND trafficvolume2 = ?', ['%s', 'localtime', 86400, 25199, '%s', 'localtime', 86400,61201, 0, 0])
                    }
                    tx.executeSql('DELETE FROM Valuetable WHERE ((strftime(?,lamlocaltime,?))%?) > ? AND ((strftime(?,lamlocaltime,?))%?) < ? AND trafficvolume1 = ? AND trafficvolume2 = ?', ['%s', 'localtime', 86400, 25199, '%s', 'localtime', 86400,61201, 0, 0])

                }
                )
}
