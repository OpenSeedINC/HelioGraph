var templist = "";


function firstload() {

    var testStr = "SELECT  *  FROM USER WHERE 1";
    var eulaStr = "SELECT * FROM announcements WHERE type = 0"

        db.transaction(function(tx) {

            tx.executeSql('CREATE TABLE IF NOT EXISTS USER (id TEXT, name TEXT, public_name TEXT,pin TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS CAPTURE (id TEXT,name TEXT,publish INT,upOrgin INT,fastCapt INT)');

            tx.executeSql('CREATE TABLE IF NOT EXISTS GROUPS (id TEXT,name TEXT,groupname TEXT,members TEXT,showprivate INT,maxRating INT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS FOLLOW (name TEXT,pin TEXT,os_account TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS SILENCE (name TEXT,pin TEXT,os_account TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS SHARES (name TEXT,pin TEXT,os_account TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS INBOX (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');



             var pull =  tx.executeSql(testStr);



            if(pull.rows.length == 0) {
                os_connect.state = "Show";
            } else {
                id = pull.rows.item(0).id;
                username = pull.rows.item(0).name;
                pin = pull.rows.item(0).pin;
               /* if(pull.rows.item(0).pin != null) {
                        pin = pull.rows.item(0).pin;
                        userpin = pull.rows.item(0).pin;
                } else {
                    pin_entry.state = "Show";
                } */

                //console.log(id,username);

                load_settings();
                heartbeats.running = true;
               // load_library(2,"");

                var checked = tx.executeSql(eulaStr);

                if(checked.rows.length != 0) {

                load_stream(" ",rate,searchstring);
                   // get_stream.running = true;
                    progress.visible = true;
                    progress.state = "midscreen";
                    info = "Please Wait";

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
   // postslist.clear();


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
        var likes = 0;
        var itsliked = 0;

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

            var checklike = "SELECT * FROM LIKES WHERE id='"+pull.rows.item(num).picture_index+"'";
            var liked = tx.executeSql(checklike);
            //console.log(liked.rows.length);
            if(liked.rows.length != 0) {
                itsliked = liked.rows.item(0).liked;
                likes = liked.rows.item(0).likes;
               // console.log(itsliked);

            } else { itsliked = 0;
                        likes = 0;}

            //console.log(pull.rows.item(num).picture_index);


            postslist.insert (num,{
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
                                  isliked:itsliked,
                                  likenums:likes

                              });


            num = num + 1;
        }
        if(library_syncing == 0) {
        get_library.running = true;
        } else {

        }
        } else {
            if(library_syncing == 0) {
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
        var likes =0;

        if(pull.rows.length != 0) {

            console.log("Images in Stream:" +pull.rows.length);

        while(pull.rows.length > num && displayed < 100) {

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
                    itsliked = liked.rows.item(0).liked;
                    likes = liked.rows.item(0).likes;
                   // console.log(itsliked);

                } else { itsliked = 0;
                            likes = 0;}


               // if(templist.search(pull.rows.item(num).picture_index+",") == -1) {
                      //  templist = pull.rows.item(num).picture_index+","+templist;
            postslist.insert (num, {
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
                                  isliked:itsliked,
                                  likenums:likes
                              });

                    //postslist.currentIndex = postslist.count;

                displayed = displayed + 1;
           // }

            }

            num = num + 1;
        }
        if(stream_syncing == 0) {
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


function load_inbox(tags,user,search) {

     //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr;
    if(search != " ") {
    testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM INBOX WHERE id  LIKE '"+user+"%' OR comment LIKE  '%"+search+"%' ORDER BY picture_index DESC ";
     } else {
     testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM INBOX WHERE id  LIKE '"+user+"%' ORDER BY picture_index DESC";

    }

   // console.log("loading inbox for: "+user);
    //thefooter.state = "Hide";
 //  postslist.clear();


    progress.visible = true;
    info = "Loading Inbox";
    whichview = 5;

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS INBOX (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


         var pull =  tx.executeSql(testStr);
        var num = 0;
        var priv = 0;
        var rating = 0;
        var theowner = "";
        var patowner = "";
        var flatowner = "";
        var displayed = 0;
        var itsliked =0;
        var likes =0;

      //console.log(pull.rows.length);
        if(pull.rows.length != 0) {

        while(pull.rows.length > num && displayed < 31) {

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

           // if(rating <= rate) {

                var checklike = "SELECT * FROM LIKES WHERE id='"+pull.rows.item(num).picture_index+"'";
                var liked = tx.executeSql(checklike);
                //console.log(liked.rows.length);
                if(liked.rows.length != 0) {
                    itsliked = liked.rows.item(0).liked;
                    likes = liked.rows.item(0).likes;
                   // console.log(itsliked);

                } else { itsliked = 0;
                            likes = 0;}



           postslist.insert (num,{
                            date:pull.rows.item(num).thedate,
                                  owner:theowner,
                                  image:"file://"+paths.split(",")[4].trim()+pull.rows.item(num).file,
                                  theeffect:pull.rows.item(num).effect,
                                  comment:pull.rows.item(num).comment,
                                  isprivate:-1,
                                  therating:rating,
                                  pic_index:pull.rows.item(num).picture_index,
                                  flatuser:flatowner,
                                  patuser:patowner,
                                  isliked:itsliked,
                                  likenums:likes
                              });

                displayed = displayed + 1;
           // }

            num = num + 1;
        }



        } //else {
          //  progress.visible = true;
          //  info = "Fetching Stream";
          //  progress.state = "midscreen";
          // get_stream.running = true;
       // }

    });



    thefooter.state = "Show";
    progress.visible = false;

    //get_stream.running = true;

}




function load_likes(tags,not,search) {

     //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    console.log("Loading Likes");

   var likesStr = "SELECT * FROM LIKES WHERE liked = 1";
    var liked = 0;

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)');


        var pull = tx.executeSql(likesStr);

        var num = 0;

        if(pull.rows.length != 0) {
        while(pull.rows.length > num) {

            if(liked == " ") {
             liked = pull.rows.item(num).id+"'";
            } else {
                liked = liked+",'"+pull.rows.item(num).id+"'";
            }


            num = num + 1;
        }
        } else {console.log("No Likes"); }

    });

    var testStr;
    if(search != " ") {
    testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM STREAM WHERE picture_index IN ('"+liked+") AND id LIKE '%"+search+"%' OR comment LIKE  '%"+search+"%' ORDER BY picture_index DESC ";
     } else {
     testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM STREAM WHERE picture_index IN ('"+liked+") ORDER BY picture_index DESC";

    }

    //console.log("Reloading Stream")
    //thefooter.state = "Hide";
  // postslist.clear();


    progress.visible = true;
    info = "Loading Stream";
    whichview = 1;

    db.transaction(function(tx) {

       // tx.executeSql('CREATE TABLE IF NOT EXISTS STREAM (thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

       // console.log(testStr);
        var pull = tx.executeSql(testStr);
        var num = 0;
        var priv = 0;
        var rating = 0;
        var theowner = "";
        var patowner = "";
        var flatowner = "";
        var displayed = 0;
        var itsliked =0;
        var likes = 0;

        if(pull.rows.length != 0) {

        while(pull.rows.length > num && displayed < 31) {

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
                    itsliked = liked.rows.item.liked;
                    likes = liked.rows.item.likes;

                } else { itsliked = 0;
                            likes = 0;}

            postslist.insert (num,{
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
                                  isliked:itsliked,
                                  likenums:likes


                              });

                displayed = displayed + 1;
            }

            num = num + 1;
        }
        if(stream_syncing == 0) {
        get_stream.running = true;
        }else {
            console.log("Stream Still syncing");
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
    var testStr2 = "SELECT  *  FROM CAPTURE WHERE 1";

    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
    tx.executeSql('CREATE TABLE IF NOT EXISTS CAPTURE (id TEXT,name TEXT,publish INT,upOrgin INT,fastCapt INT)');

        var pull = tx.executeSql(testStr);
        var pull2 = tx.executeSql(testStr2);

        if(pull.rows.length != 0) {
            if(pull.rows.item(0).name != null) {
            publicname = pull.rows.item(0).name;
            }
            rate = pull.rows.item(0).max_rating;

            if(pull.rows.item(0).patreon != null) {
           patreon = pull.rows.item(0).patreon;
            }
            if(pull.rows.item(0).flattr != null) {
            flattr = pull.rows.item(0).flattr;
            }

        }

        if(pull2.rows.length != 0) {

            privsetting = pull2.rows.item(0).publish;

            console.log("Share with others?: "+privsetting);

            uploadoriginal = pull2.rows.item(0).upOrgin;


           fastcapture = pull2.rows.item(0).fastCapt;

        }



        //console.log(username,rate,patreon,flattr);
    });




}


function store_img (where,file,effect,private,comment) {

   //  var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr = "SELECT  *  FROM LIBRARY WHERE 1";

    var d = new Date();


    var thedate = d.getMonth()+1+"-"+d.getDate()+"-"+d.getFullYear();

    //console.log(file);

    var base64 = file.split(":;:")[1];

    var data = [id,where,file.split(":;:")[2]+".jpg",effect,comment,thedate,private,9999999,base64];

     var insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT, base64 BLOB)');

            tx.executeSql(insert,data);

    });



}

function store_setting (publicname,maxrate,patreon,flattr,pin,publish,uporgin,fastcapt) {


    var testStr = "SELECT  *  FROM SETTINGS WHERE 1";

    var data = [id,publicname,maxrate,patreon,flattr];

    var insert = "INSERT INTO SETTINGS VALUES(?,?,?,?,?)";

    var update = "UPDATE SETTINGS SET name ='"+publicname+"', max_rating='"+maxrate+"', patreon='"+patreon+"', flattr='"+flattr+"' WHERE id ='"+id+"'";
    var updatepin = "UPDATE USER SET pin='"+pin+"' WHERE id='"+id+"'";


    var testStr2 = "SELECT  *  FROM CAPTURE WHERE 1";

    var data2 = [id,publicname,publish,uporgin,fastcapt];

    var insert2 = "INSERT INTO CAPTURE VALUES(?,?,?,?,?)";

    var update2 = "UPDATE CAPTURE SET name ='"+publicname+"', publish='"+publish+"', upOrgin='"+uporgin+"', fastCapt='"+fastcapt+"' WHERE id ='"+id+"'";


    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');
    tx.executeSql('CREATE TABLE IF NOT EXISTS CAPTURE (id TEXT,name TEXT,publish INT,upOrgin INT,fastCapt INT)');

        var pull = tx.executeSql(testStr);
        var pull2 = tx.executeSql(testStr2);

        if(pull.rows.length == 0) {
            tx.executeSql(insert,data);
        } else {
            tx.executeSql(update);
        }

        if(pull2.rows.length == 0) {
            tx.executeSql(insert2,data2);
        } else {
            tx.executeSql(update2);
        }


        tx.executeSql(updatepin);


    });

}


function load_follows() {

    var testStr = "SELECT  *  FROM FOLLOW WHERE 1";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS FOLLOW (name TEXT,pin TEXT,os_account TEXT)');

        var pull = tx.executeSql(testStr);

        if(pull.rows.length != 0) {
            var num = 0;
            while (num < pull.rows.length) {
                followlist.append({

                                      type:"button",
                                      menuItem:1,
                                      menuText:pull.rows.item(num).name,
                                      buttonColor:"#202020"


                                  });

                num = num + 1;
            }

        }

        //console.log(username,rate,patreon,flattr);
    });

}


function load_shares() {

    var testStr = "SELECT  *  FROM SHARES WHERE 1";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS SHARES (name TEXT,pin TEXT,os_account TEXT)');

        var pull = tx.executeSql(testStr);

        if(pull.rows.length != 0) {
            var num = 0;
            var names = "";
            while (num < pull.rows.length) {

                    if(names.search(pull.rows.item(num).name) == -1) {
                followlist.append({

                                      type:"button",
                                      menuItem:1,
                                      menuText:pull.rows.item(num).name,
                                      buttonColor:"#202020"


                                  });

                    }

                    if(names = "") {
                        names = pull.rows.item(num).name;
                    } else {
                        names = names+","+pull.rows.item(num).name;
                    }

                num = num + 1;
            }

        }

        //console.log(username,rate,patreon,flattr);
    });

}


function checkstuff(account) {
    var followtest = "SELECT  name  FROM FOLLOW WHERE os_account ='"+account+"'";
    var silencetest = "SELECT name  FROM SILENCE WHERE os_account = '"+account+"'";

    //console.log(account);

    db.transaction(function(tx) {
       var isfollowing = tx.executeSql(followtest);
        var issilenced = tx.executeSql(silencetest);

        if(isfollowing.rows.length != 0) {
            console.log(isfollowing.rows.item(0).name);
            follow = 1;
        }
        if(issilenced.rows.length != 0) {
            console.log(issilenced.rows.item(0).name);
            silenced = 1;
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

function viewOthers(search) {

    //console.log("Creating Preview for "+search);
     //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    var testStr;

    testStr = "SELECT id,thedir,file,effect,comment,thedate,private,picture_index FROM STREAM WHERE id LIKE '"+search+":%' ORDER BY picture_index DESC ";

   imagelist.clear();


    //progress.visible = true;
   // info = "Loading";
    //whichview = 1;

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

        //console.log("Images found "+pull.rows.length);

        if(pull.rows.length != 0) {

        while(pull.rows.length > num && displayed < 8) {


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


                //console.log(pull.rows.item(num).file);

            imagelist.append ({
                                  img:"file://"+paths.split(",")[3].trim()+pull.rows.item(num).file

                              });

                displayed = displayed + 1;
            }

            num = num + 1;
        }


        }

    });

}

function groups_list() {

    var testStr;

    testStr = "SELECT * FROM GROUPS WHERE 1";
    var publicexists = "SELECT groupname FROM GROUPS WHERE groupname ='Public'";
    var followersexists = "SELECT groupname FROM GROUPS WHERE groupname ='Followers'";

   groups.clear();


    db.transaction(function(tx) {

         tx.executeSql('CREATE TABLE IF NOT EXISTS GROUPS (id TEXT,name TEXT,groupname TEXT,members TEXT,showprivate INT,maxRating INT)');

        var pubis = tx.executeSql(publicexists);
        var folis = tx.executeSql(followersexists);
        if(pubis.rows.length == 0) {
         tx.executeSql('INSERT INTO GROUPS (id,name,groupname,members,showprivate,maxRating) VALUES("'+id+'","'+username+'","Public"," ",0,0);');
        }
        if(folis.rows.length == 0) {
         tx.executeSql('INSERT INTO GROUPS (id,name,groupname,members,showprivate,maxRating) VALUES("'+id+'","'+username+'","Followers"," ",1,2);');
        }

        var pull = tx.executeSql(testStr);

        var groupnum = 0;

        while(pull.rows.length > groupnum) {


            groups.append({
                        name:pull.rows.item(groupnum).groupname,
                        grouprating:pull.rows.item(groupnum).maxRating,
                        seeprivate:pull.rows.item(groupnum).showprivate

                        });

            groupnum =groupnum + 1;
        }


    });



}


function groups_update(groupname,showprivate,maxrating) {

    var testStr;

    testStr = "SELECT * FROM GROUPS WHERE groupname ='"+groupname+"'";


    db.transaction(function(tx) {

         tx.executeSql('CREATE TABLE IF NOT EXISTS GROUPS (id TEXT,name TEXT,groupname TEXT,members TEXT,showprivate INT,maxRating INT)');

        var pull = tx.executeSql(testStr);

        if(pull.rows.length == 0) {
            tx.executeSql('INSERT INTO GROUPS (id,name,groupname,members,showprivate,maxRating) VALUES("'+id+'","'+username+'","'+groupname+'"," ",'+showprivate+','+maxrating+'); ');
        } else {
            tx.executeSql("UPDATE GROUPS SET showprivate='"+showprivate+"', maxRating='"+maxrating+"' WHERE groupname='"+groupname+"'");
        }

    });

    groups_list();


}
