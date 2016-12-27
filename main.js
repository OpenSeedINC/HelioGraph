
function firstload() {

    var testStr = "SELECT  *  FROM USER WHERE 1";
    var eulaStr = "SELECT * FROM announcements WHERE type = 0"

        db.transaction(function(tx) {

            tx.executeSql('CREATE TABLE IF NOT EXISTS USER (id TEXT, name TEXT, public_name TEXT,pin TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)')


             var pull =  tx.executeSql(testStr);



            if(pull.rows.length == 0) {
                os_connect.state = "Show";
            } else {
                id = pull.rows.item(0).id;
                username = pull.rows.item(0).name;
               /* if(pull.rows.item(0).pin != null) {
                        pin = pull.rows.item(0).pin;
                        userpin = pull.rows.item(0).pin;
                } else {
                    pin_entry.state = "Show";
                } */

                load_settings();
                heartbeats.running = true;
               // load_library(2,"");

                var checked = tx.executeSql(eulaStr);

                if(checked.rows.length != 0) {

                load_stream(" ",rate,searchstring);
                   // get_stream.running = true;
                    //progress.visible = true;
                   // info = "v0.9.5";

                } else {
                    agreement.state = "Show";
                }
            }

        });

}


function load_library(firstrun,search) {

     //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr = "SELECT thedir,file,effect,comment,thedate,private,picture_index FROM LIBRARY WHERE private !=2 ORDER BY picture_index DESC ";

    //console.log("Reloading Library")
    //thefooter.state = "Hide";
    postslist.clear();


    whichview = 0;

    if(search != " ") {
    testStr = "SELECT thedir,file,effect,comment,thedate,private,picture_index FROM LIBRARY WHERE private !=2 id LIKE '%"+search+"%' OR comment LIKE  '%"+search+"%' ORDER BY picture_index DESC ";
     } else {
     testStr = "SELECT thedir,file,effect,comment,thedate,private,picture_index FROM LIBRARY WHERE private !=2 ORDER BY picture_index DESC";

    }


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


         var pull =  tx.executeSql(testStr);
        var num = 0;
        var priv = 0;
        var rating = 0;

        if(pull.rows.length != 0) {

        while(pull.rows.length > num) {

            //var thefile = paths.split(",")[2].trim()+pull.rows.item(num).file+":;:"+pull.rows.item(num).base64;


            if(pull.rows.item(num).private.length > 1) {
                priv = parseInt(pull.rows.item(num).private.split(":;:")[0]);
                rating = parseInt(pull.rows.item(num).private.split(":;:")[1]);
            } else {
                priv = pull.rows.item(num).private;
                rating = 0;
            }
            //console.log(pull.rows.item(num).picture_index);

            /*if(pull.rows.item(num).picture_index == 9999999) {
                get_library.running = true;
            } */

            postslist.append ({
                            date:pull.rows.item(num).thedate,
                                  owner:username,
                                  image:"file://"+paths.split(",")[2].trim()+pull.rows.item(num).file,
                                  theeffect:pull.rows.item(num).effect,
                                  comment:pull.rows.item(num).comment,
                                  isprivate:priv,
                                  therating:rating,
                                  pic_index:pull.rows.item(num).picture_index,
                                  flatuser:flattr,
                                  patuser:patreon,
                                  isliked:0

                              });


            num = num + 1;
        }
        if(syncing == 0) {
        get_library.running = true;
        } else {

        }
        } else {
            if(syncing == 0) {
                 progress.visible = true;
                 info = "Loading Library";
           get_library.running = true;
            }
        }

    });

    thefooter.state = "Show";
   // progress.visible = false;


}


function load_stream(tags,not,search) {

     //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr;
    if(search != " ") {
    testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM STREAM WHERE id LIKE '%"+search+"%' OR comment LIKE  '%"+search+"%' ORDER BY picture_index DESC ";
     } else {
     testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM STREAM WHERE 1 ORDER BY picture_index DESC";

    }

    //console.log("Reloading Stream")
    //thefooter.state = "Hide";
   postslist.clear();


    progress.visible = true;
    info = "Loading Stream";
    whichview = 1;

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS STREAM (thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


         var pull =  tx.executeSql(testStr);
        var num = 0;
        var priv = 0;
        var rating = 0;
        var theowner = "";
        var patowner = "";
        var flatowner = "";
        var displayed = 0;
        var itsliked =0;

        if(pull.rows.length != 0) {

        while(pull.rows.length > num && displayed < 21) {

            //var thefile = paths.split(",")[2].trim()+pull.rows.item(num).file+":;:"+pull.rows.item(num).base64;


            if(pull.rows.item(num).private.length > 1) {
                priv = parseInt(pull.rows.item(num).private.split(":;:")[0]);
                rating = parseInt(pull.rows.item(num).private.split(":;:")[1]);
            } else {
                priv = pull.rows.item(num).private;
                rating = 0;
            }


            if(pull.rows.item(num).id.search("::") != -1) {
                    theowner = pull.rows.item(num).id.split("::")[0];
                    flatowner = pull.rows.item(num).id.split("::")[1];
                    patowner = pull.rows.item(num).id.split("::")[2];
            } else {
                    patowner = " ";
                    flatowner = " ";
                    theowner = pull.rows.item(num).id;
            }

            if(rating <= rate) {

                var checklike = "SELECT * FROM LIKES WHERE id='"+pull.rows.item(num).picture_index+"'";
                var liked = tx.executeSql(checklike);
                //console.log(liked.rows.length);
                if(liked.rows.length != 0) {
                    itsliked = 1;
                } else { itsliked = 0; }

            postslist.append ({
                            date:pull.rows.item(num).thedate,
                                  owner:theowner,
                                  image:"file://"+paths.split(",")[3].trim()+pull.rows.item(num).file,
                                  theeffect:pull.rows.item(num).effect,
                                  comment:pull.rows.item(num).comment,
                                  isprivate:-1,
                                  therating:rating,
                                  pic_index:pull.rows.item(num).picture_index,
                                  flatuser:flatowner,
                                  patuser:patowner,
                                  isliked:itsliked
                              });

                displayed = displayed + 1;
            }

            num = num + 1;
        }
        if(syncing == 0) {
        get_stream.running = true;
        }else {
            console.log("Still syncing");
        }


        } //else {
          //  progress.visible = true;
          //  info = "Fetching Stream";
          //  progress.state = "midscreen";
          // get_stream.running = true;
       // }

    });



    thefooter.state = "Show";
   // progress.visible = false;

    //get_stream.running = true;

}

function load_settings() {

    var testStr = "SELECT  *  FROM SETTINGS WHERE 1";

    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
        var pull = tx.executeSql(testStr);

        if(pull.rows.length != 0) {
            if(pull.rows.item(0).name != null) {
            username = pull.rows.item(0).name;
            }
            rate = pull.rows.item(0).max_rating;

            if(pull.rows.item(0).patreon != null) {
           patreon = pull.rows.item(0).patreon;
            }
            if(pull.rows.item(0).flattr != null) {
            flattr = pull.rows.item(0).flattr;
            }

        }

        //console.log(username,rate,patreon,flattr);
    });


}


function store_img (where,file,effect,private,comment) {

   //  var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr = "SELECT  *  FROM LIBRARY WHERE 1";

    var d = new Date();


    var thedate = d.getMonth()+1+"-"+d.getDate()+"-"+d.getFullYear();

    var base64 = file.split(":;:")[1];

    var data = [id,where,file.split(":;:")[2]+".jpg",effect,comment,thedate,private,9999999,base64];

     var insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT, base64 BLOB)');

            tx.executeSql(insert,data);

    });



}

function store_setting (newname,maxrate,patreon,flattr) {
   // console.log(newname);
  //  console.log(maxrate);
  //  console.log(patreon);
  //  console.log(flattr);

    var testStr = "SELECT  *  FROM SETTINGS WHERE 1";

    var data = [id,newname,maxrate,patreon,flattr];

    var insert = "INSERT INTO SETTINGS VALUES(?,?,?,?,?)";

    var update = "UPDATE SETTINGS SET name ='"+newname+"', max_rating='"+maxrate+"', patreon='"+patreon+"', flattr='"+flattr+"' WHERE id ='"+id+"'";
    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
        var pull = tx.executeSql(testStr);

        if(pull.rows.length == 0) {
            tx.executeSql(insert,data);
        } else {
            tx.executeSql(update);
        }

    });

}


function update_index(file,effect,date,retrieved) {

   // var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var thefile = file.split(":;:")[1].trim()+".jpg";

            var base64 = file.split(":;:")[0].replace(/ /g,"+");

        info = "Updating Index";


     var insert = "UPDATE LIBRARY SET picture_index='"+retrieved+"' WHERE file='"+thefile+"' AND base64 = '"+base64+"' AND thedate='"+date+"' AND effect='"+effect+"'";
    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

            //var pull = tx.executeSql(testStr);

            //if(pull.rows.length != 0) {

            tx.executeSql(insert);

            //} else {
              //  console.log("Didn't find him");
            //}

            //reload.running = true;
    });


    progress.visible = false;
    info = " ";

}

