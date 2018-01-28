var updateinterval = 2000;
//var fullnumber = 0;
var stream_fullnumber = 0;
var library_fullnumber = 0;

function oseed_auth(name,email,passphrase) {

    var http = new XMLHttpRequest();
    //var url = "https://openseed.vagueentertainment.com:8675/corescripts/auth.php?devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email ;
    var url = "https://openseed.vagueentertainment.com:8675/corescripts/authPOST.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
              //  console.log(http.responseText);
                id = http.responseText;
                createdb();
            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email+ "&passphrase=" + passphrase);
    //be sure to remove this when the internet is back and before we distribute//
    //id = "00010101";

    //createdb();
}

function createdb() {

   // var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);
    var userStr = "INSERT INTO USER VALUES(?,?,?,?)";

    var numofaccounts = 0;

    var updateUser = "UPDATE USER SET name='"+username+"', WHERE id='"+id+"'";
    var data = [id,username," "," "];

    var testStr = "SELECT  *  FROM USER WHERE id= '"+id+"'";

    var accountsStr = "SELECT  *  FROM USER WHERE 1 ";

        db.transaction(function(tx) {

           tx.executeSql('CREATE TABLE IF NOT EXISTS USER (id TEXT, name TEXT, public_name TEXT,pin TEXT)');
           tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');
           tx.executeSql('CREATE TABLE IF NOT EXISTS SETTINGS (id TEXT,name TEXT,max_rating INT,patreon TEXT,flattr TEXT)');


                            var test1 = tx.executeSql(accountsStr);

                                numofaccounts = test1.rows.length;

                        var test = tx.executeSql(testStr);


                            if(test.rows.length == 0) {
                                if (id.length > 4) {
                                tx.executeSql(userStr,data);
                                }
                            } else {

                            tx.executeSql(updateUser);

                                }



        });


    db.transaction(function(tx) {

        var followsStr = "SELECT * FROM FOLLOW WHERE 1";

            tx.executeSql('CREATE TABLE IF NOT EXISTS FOLLOW (name TEXT,pin TEXT,os_account TEXT)');

    });


    db.transaction(function(tx) {

        var taskStr = "SELECT * FROM TAGS WHERE 1";

           tx.executeSql('CREATE TABLE IF NOT EXISTS TAGS (name TEXT,os_account TEXT,allowed INT)');

    });


    db.transaction(function(tx) {

        var taskStr = "SELECT * FROM LIBRARY WHERE 1";

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS STREAM (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS INBOX (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

    });

   // reload.running = true;

    //get_stream.running = true;

    firstrun.running = true;


}

function checkcreds(field,info) {

    var http = new XMLHttpRequest();
    //var url = "https://openseed.vagueentertainment.com:8675/corescripts/auth.php?devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email ;
    var url = "https://openseed.vagueentertainment.com:8675/corescripts/authCHECK.php";
   // console.log("sending "+name+" , "+passphrase);
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                uniquemail = 100;
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {

                uniquemail = 101;
                console.log("Incorrect AppID");
            } else {
                console.log(http.responseText);
                //id = http.responseText;
                if(field == "email") {
                    uniquemail = http.responseText;
                }
                if(field == "username") {
                    uniquename = http.responseText;
                }

                if(field == "account") {
                    uniqueaccount = http.responseText;
                }

                if(field == "passphrase") {
                    uniqueid = http.responseText;
                }
            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&type="+ field + "&info=" + info);


}


function accountlist() {

   // var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

    accesslist.clear();

     var testStr = "SELECT  *  FROM ACCOUNTS WHERE 1";


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS ACCOUNTS (name TEXT,id TEXT,family TEXT)');

         var pull =  tx.executeSql(testStr);
        var num = 0;
        var numofchildren = 0;

            while (pull.rows.length > num) {


                accesslist.append ({

                                       accountname:pull.rows.item(num).family,
                                       familyid:pull.rows.item(num).id,
                                       childnumber:numofchildren


                                   });

                num = num + 1;
            }

            accesslist.append ({

                                   accountname:"1",
                                   familyid:"1",
                                   childnumber:numofchildren


                               });

    });


}



function heartbeat() {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/corescripts/heartbeat.php";
   // console.log(url)

    http.onreadystatechange = function() {

       if(http.status == 200) {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

                heart = http.responseText;
                updateinterval = 10000;

             // console.log(heart);

            }

        }
            } else {
                    heart = "Offline";
                    updateinterval = 2000 + updateinterval;

        }
    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&userid="+ id);

    heartbeats.interval = updateinterval;

}


function sendimage(userid,file,effect,comment,date,private) {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //var sending = file.split(":;:")[0];
    var retrieved;
   // console.log(url)

    //console.log(sending);

    var d = new Date();
    var thedate = d.getMonth()+1+"-"+d.getDate()+"-"+d.getFullYear();
    if(date == " ") {
        date = thedate;
    } else {
        date = date;
    }

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                retrieved = http.responseText;
                console.log(retrieved);

                update_index(file,effect,date,retrieved);
            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ userid + "&username="+username+"&file="+
              file.trim()+"&effect="+effect+"&comment="+comment+"&date="+date+"&private="+private+"&flattr="+flattr+
              "&patreon="+patreon+"&info6="+publicname+"&type=IMAGE &action=sending" );

}



function retrievedata(type,serverhas) {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    console.log("Getting: "+type+" "+serverhas);
   // console.log(url)

        var serverfun = "";

        var tags = "any";
        var not = "any";

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

                var stuffnum = 1;
                var sitedata =http.responseText.split(">!<");
                //console.log(sitedata[0]);


                    switch(type) {
                    case "IMAGE":store_img("Library",sitedata[stuffnum].split(":retrieved:")[0],
                                           sitedata[stuffnum].split(":retrieved:")[1],
                                           sitedata[stuffnum].split(":retrieved:")[4],
                                           sitedata[stuffnum].split(":retrieved:")[2],
                                           sitedata[stuffnum].split(":retrieved:")[3],
                                           sitedata[stuffnum].split(":retrieved:")[5],id,flattr,patreon);
                                           // reload.running = true;
                                            sitedata = " ";
                                            break;

                    case "STREAM":store_img("Stream",sitedata[stuffnum].split(":retrieved:")[0],
                                           sitedata[stuffnum].split(":retrieved:")[1],
                                           sitedata[stuffnum].split(":retrieved:")[4],
                                           sitedata[stuffnum].split(":retrieved:")[2],
                                           sitedata[stuffnum].split(":retrieved:")[3],
                                           sitedata[stuffnum].split(":retrieved:")[5],
                                            sitedata[stuffnum].split(":retrieved:")[6],
                                            sitedata[stuffnum].split(":retrieved:")[7],
                                             sitedata[stuffnum].split(":retrieved:")[8]
                                            );
                                         //  stream_reload.running = true;



                                            sitedata = " ";
                                            break;

                    case "SHARE":store_img("Share",sitedata[stuffnum].split(":retrieved:")[0],
                                           sitedata[stuffnum].split(":retrieved:")[1],
                                           sitedata[stuffnum].split(":retrieved:")[4],
                                           sitedata[stuffnum].split(":retrieved:")[2],
                                           sitedata[stuffnum].split(":retrieved:")[3],
                                           sitedata[stuffnum].split(":retrieved:")[5],
                                            sitedata[stuffnum].split(":retrieved:")[6],
                                            sitedata[stuffnum].split(":retrieved:")[7],
                                             sitedata[stuffnum].split(":retrieved:")[8]
                                            );
                                            //console.log("TO Share: "+serverhas);
                                         //  stream_reload.running = true;
                                            sitedata = " ";
                                            break;

                    default:break;

                    }

               // fetched = 1;

              //console.log(http.responseText);

            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    switch(type) {
    case "IMAGE":http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&type="+type+"&file="+serverhas+"&action=pulling");break;
    case "STREAM":http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&type="+type+"&file="+serverhas+"&info1="+tags+"&info2="+not+"&action=pullstream");break;
    case "SHARE":http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&type="+type+"&file="+serverhas+"&info1="+tags+"&info2="+not+"&action=pullshare");break;
    default:break;
    }

}

function sync_library() {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

        whichview = 0;

    gc();

   // postslist.clear();

    library_imagequeue = " ";

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

              var numonserver =http.responseText;



              // console.log(numonserver);

               // var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);

                var testStr = "SELECT  *  FROM LIBRARY WHERE picture_index IN ('',' ','0','9999999')";

                var stuffStr = "SELECT  *  FROM LIBRARY WHERE 1"

                db.transaction(function(tx) {

                    tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


                     var pull =  tx.executeSql(stuffStr);

                     var push = tx.executeSql(testStr);

                    var serverindex = 1;
                    var foundnew  = 0;
                    library_fetchedimage = 0;
                    //newimages = numonserver.split(">!<").length;

                    progress.visible = true;



                  /*  if(push.rows.length > 0) {
                        info = "Pushing to server";

                        var sendnum = 0;
                        while(sendnum < push.rows.length && sendnum < 4) {

                            sendimage(push.rows[sendnum].id,
                                      push.rows[sendnum].base64+":;:"+push.rows[sendnum].file.split(".jpg")[0],
                                      push.rows[sendnum].effect,
                                      push.rows[sendnum].comment,
                                      push.rows[sendnum].thedate,
                                      push.rows[sendnum].private
                                      );

                            sendnum = sendnum + 1;
                        }


                    } */

                    while(numonserver.split(">!<").length > serverindex) {
                      // console.log(numonserver.split(">!<")[serverindex]);
                        var exists = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+numonserver.split(">!<")[serverindex]+"'";
                            var check = tx.executeSql(exists);
                        if(check.rows.length == 0) {
                            // retrievedata("IMAGE",numonserver.split(">!<")[serverindex]);
                            if(library_imagequeue == " ") {
                            library_imagequeue = numonserver.split(">!<")[serverindex];

                            } else {
                                library_imagequeue = library_imagequeue+","+numonserver.split(">!<")[serverindex];
                            }

                            foundnew = foundnew +1;
                        }

                        serverindex = serverindex + 1;
                    }



                    library_newimages = foundnew;

                    if(library_newimages == 0) {
                     //reload.running = true;
                        library_syncing = 0;
                     progress.visible = false;
                        beep.running = false;
                    } else {
                        info = "Syncing Library: ";
                        library_syncing = 1;
                        beep.running = true;
                        info = library_fetchedimage+"/"+library_newimages;
                       // thefooter.state = "Hide";
                        //console.log(newimages);

                    }

                });


            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&action=sync" );


}


function social_stream(tags,not,search) {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //console.log("OpenSeed.js "+childname,account);
    //console.log(url)

   // console.log("Search:"+search+"\nRating:"+not+"\nAnd Tags:"+tags);

    var type = "STREAM";



   // postslist.clear();

    stream_fetchedimage = 0;


    stream_imagequeue = " ";


    gc();

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

                var stuffnum = 1;
                var sitedata =http.responseText.split(">!<");
                var foundnew = 0;


               //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1000000);


                db.transaction(function(tx) {
                    var testing = 0;



              while(sitedata.length > stuffnum && stuffnum <= 20) {


                       // console.log(sitedata[stuffnum]);

                  var exists = "SELECT picture_index FROM STREAM WHERE picture_index ='"+sitedata[stuffnum]+"'";
                      var check = tx.executeSql(exists);

                  if(check.rows.length == 0) {
                     // retrievedata("STREAM",sitedata[stuffnum]);
                      foundnew = foundnew +1;

                      if(stream_imagequeue == " ") {
                      stream_imagequeue = sitedata[stuffnum];

                      } else {
                          stream_imagequeue = stream_imagequeue+","+sitedata[stuffnum];
                      }


                  }


                stuffnum = stuffnum + 1;


            }



                });

                stream_newimages = foundnew;

                if (stream_newimages == 0) {
                    //stream_reload.running = true;
                    progress.visible = false;

                    stream_syncing = 0;


                } else {
                    progress.state = "minimal";
                     progress.visible = true;
                     stream_syncing = 1;
                        info = "Updating Stream";
                    console.log("Found new images: "+stream_newimages+" indexs "+stream_imagequeue);

                    boop.running = true;
                    info = stream_fetchedimage+"/"+stream_newimages;
                     //thefooter.state = "Hide";
                }

               // stream_reload.running = true;



              //console.log(http.responseText);

            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&type="+type+"&tags="+tags+"&rate="+not+"&search="+search+"&action=stream" );



}

function store_img (where,file,effect,private,comment,thedate,picture_index,id,flattr,patreon) {

   //var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 10000000000);


    var thefile ="";
    var testStr = "";
    var insert = "";
    var justfile = "";

    var data ="";

    //console.log(where);

    //var testStr = "SELECT  *  FROM LIBRARY WHERE file='"+thefile+"' AND effect='"+effect+"' AND thedate='"+thedate+"'";

    var base64 = file.split(":;:")[0].replace(/ /g,"+");


    switch(where) {
     case "Library":
         thefile = paths.split(",")[2].trim()+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =file.split(":;:")[1].trim()+".jpg";
         testStr = "SELECT * FROM LIBRARY WHERE file = '"+justfile+"' AND picture_index ='"+picture_index+"'";
         data = [id,where,justfile,effect,comment,thedate,private,picture_index,base64];

                        break;
     case "Stream":
         thefile = paths.split(",")[3].trim()+id+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO STREAM VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =id+file.split(":;:")[1].trim()+".jpg";
         testStr = "SELECT * FROM STREAM WHERE file = '"+justfile+"' AND picture_index ='"+picture_index+"'";
         data = [id+"::"+flattr+"::"+patreon,where,justfile,effect,comment,thedate,private,picture_index,base64];

                    break;

     case "Share":
         //console.log(paths.split(","));
         thefile = paths.split(",")[4].trim()+id+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO INBOX VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =id+file.split(":;:")[1].trim()+".jpg";
         testStr = "SELECT * FROM INBOX WHERE file = '"+justfile+"' AND picture_index ='"+picture_index+"'";
         data = [id+"::"+flattr+"::"+patreon,where,justfile,effect,comment,thedate,private,picture_index,base64];

                    break;

     default:
         thefile = paths.split(",")[2].trim()+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =file.split(":;:")[1].trim()+".jpg";
         testStr = "SELECT * FROM LIBRARY WHERE file = '"+justfile+"' AND picture_index ='"+picture_index+"'";
         data = [id,where,justfile,effect,comment,thedate,private,picture_index,base64];

                        break;
    }





    //var base64 = "na";



 try {
    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS STREAM (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS INBOX (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


            var pull = tx.executeSql(testStr);

           // console.log(pull.rows.length);
            if(pull.rows.length == 0) {

               fileio.image = thefile;
                tx.executeSql(insert,data);
               // fetchedimage = fetchedimage + 1;
               // console.log(fetchedimage+" adding "+justfile);



            }
             switch(where) {
             case "Library":library_fetchedimage = library_fetchedimage + 1;break;
             case "Stream":stream_fetchedimage = stream_fetchedimage + 1;break;
             case "Share":stream_fetchedimage = stream_fetchedimage + 1;break;
             default:library_fetchedimage = library_fetchedimage + 1;break;
             }


    });
 } catch (err) {
        console.log("Error creating file: " + err);
 }

    //console.log(newimages+"/"+fetchedimage);



    switch(where) {

    case "Library":
    if(library_newimages >= 31) {
        library_fullnumber = library_newimages;
        library_newimages = 30;

        info = library_fetchedimage+"/"+library_newimages+" (of "+library_fullnumber+")";

    } else {
        if(library_fullnumber == 0) {
        info = library_fetchedimage+"/"+library_newimages;
        } else {
            info = library_fetchedimage+"/"+library_newimages+" (of "+library_fullnumber+")";
        }
    }

    if(library_fetchedimage != 0) {
        //progress.state = "minimal";
        switch(where) {
            case "Library":thefooter.state = "Show"; /*reload.running = true; */ break;
            case "Stream":thefooter.state = "Show"; /* stream_reload.running = true; */ break;
            case "Share":thefooter.state = "Show"; /* stream_reload.running = true;*/ break;
            default:thefooter.state = "Show"; /* reload.running = true; */ break;
        }

    }



    if(library_fetchedimage == library_newimages) {
      //  progress.state = "midscreen";
        library_syncing = 0;
        library_imagequeue = "";
        library_newimages = 0;
        menu_notifications();

        thefooter.state = "Show";
        if(postslist.count == 0 ) {reload.running = true;}
        progress.visible = false;


    } break;


    default:
    if(library_newimages >= 31) {
        library_fullnumber = library_newimages;
        library_newimages = 30;

        info = library_fetchedimage+"/"+library_newimages+" (of "+library_fullnumber+")";

    } else {
        if(library_fullnumber == 0) {
        info = library_fetchedimage+"/"+library_newimages;
        } else {
            info = library_fetchedimage+"/"+library_newimages+" (of "+library_fullnumber+")";
        }
    }

    if(library_fetchedimage != 0) {
        //progress.state = "minimal";
        switch(where) {
            case "Library":thefooter.state = "Show"; /*reload.running = true; */ break;
            case "Stream":thefooter.state = "Show"; /* stream_reload.running = true; */ break;
            case "Share":thefooter.state = "Show"; /* stream_reload.running = true;*/ break;
            default:thefooter.state = "Show"; /* reload.running = true; */ break;
        }

    }



    if(library_fetchedimage == library_newimages) {
      //  progress.state = "midscreen";
        library_syncing = 0;
        library_imagequeue = "";
        library_newimages = 0;
        menu_notifications();

        thefooter.state = "Show";
        if(postslist.count == 0 ) {reload.running = true;}
        progress.visible = false;


    } break;

    case "Stream":
    if(stream_newimages >= 31) {
        stream_fullnumber = stream_newimages;
        stream_newimages = 30;

        info = stream_fetchedimage+"/"+stream_newimages+" (of "+stream_fullnumber+")";

    } else {
        if(stream_fullnumber == 0) {
        info = stream_fetchedimage+"/"+stream_newimages;
        } else {
            info = stream_fetchedimage+"/"+stream_newimages+" (of "+stream_fullnumber+")";
        }
    }

    if(stream_fetchedimage != 0) {
        //progress.state = "minimal";
        switch(where) {
            case "Library":thefooter.state = "Show"; /*reload.running = true; */ break;
            case "Stream":thefooter.state = "Show"; /* stream_reload.running = true; */ break;
            case "Share":thefooter.state = "Show"; /* stream_reload.running = true;*/ break;
            default:thefooter.state = "Show"; /* reload.running = true; */ break;
        }

    }



    if(stream_fetchedimage == stream_newimages) {
      //  progress.state = "midscreen";
        stream_syncing = 0;
        stream_imagequeue = "";
        stream_newimages = 0;
        menu_notifications();

        thefooter.state = "Show";
        if(postslist.count == 0 ) {reload.running = true;}
        progress.visible = false;


    } break;

    case "Share":
    if(stream_newimages >= 31) {
        stream_fullnumber = stream_newimages;
        stream_newimages = 30;

        info = stream_fetchedimage+"/"+stream_newimages+" (of "+stream_fullnumber+")";

    } else {
        if(stream_fullnumber == 0) {
        info = stream_fetchedimage+"/"+stream_newimages;
        } else {
            info = stream_fetchedimage+"/"+stream_newimages+" (of "+stream_fullnumber+")";
        }
    }

    if(stream_fetchedimage != 0) {
        //progress.state = "minimal";
        switch(where) {
            case "Library":thefooter.state = "Show"; /*reload.running = true; */ break;
            case "Stream":thefooter.state = "Show"; /* stream_reload.running = true; */ break;
            case "Share":thefooter.state = "Show"; /* stream_reload.running = true;*/ break;
            default:thefooter.state = "Show"; /* reload.running = true; */ break;
        }

    }



    if(stream_fetchedimage == stream_newimages) {
      //  progress.state = "midscreen";
        stream_syncing = 0;
        stream_imagequeue = "";
        stream_newimages = 0;
        menu_notifications();

        thefooter.state = "Show";
        if(postslist.count == 0 ) {reload.running = true;}
        progress.visible = false;


    } break;





}

    gc();
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

            tx.executeSql(insert);


            //reload.running = true;
    });


    progress.visible = false;
    info = " ";

}

function get_eula() {
    var http = new XMLHttpRequest();
    var url = "http://vagueentertainment.com/standard-license.html"

    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');
    });

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

                message = http.responseText.split('<body lang="en-US" dir="ltr">')[1].split("</body>")[0];
              //console.log(http.responseText);

            }

        }

    http.open('GET', url.trim(), true);

    http.send(null);

}

function get_news(log) {
    var http = new XMLHttpRequest();
    var url = "http://vagueentertainment.com/"+log+".html"

    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');
    });

    http.onreadystatechange = function() {

        if (http.readyState == 4) {



                message = http.responseText.split('<body lang="en-US" dir="ltr">')[1].split("</body>")[0];
              //console.log(http.responseText);

            }

        }

    http.open('GET', url.trim(), true);

    http.send(null);

}

function announcement_seen(type) {

     var data = [id,username,type,1,1];
    var insert = "INSERT INTO announcements VALUES(?,?,?,?,?)";
    db.transaction(function(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS announcements (id TEXT, name TEXT,type TEXT,version INT,seen INT)');

        tx.executeSql(insert,data);


    });


}

function privacy_update(index,type,shareto) {

    var insert = "UPDATE LIBRARY SET private='"+type+"' WHERE picture_index='"+index+"'";
    var sharing = "";
   db.transaction(function(tx) {

       tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

          // var pull = tx.executeSql(testStr);

          // if(pull.rows.length != 0) {
            console.log("updating "+index);
           tx.executeSql(insert);

          // }
           //reload.running = true;
   });

    if(shareto != " ") {
        sharing = shareto;
    } else {
        sharing = "all";
    }



    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //var sending = file.split(":;:")[0];
    var retrieved;
   // console.log(url)

    //console.log(sending);

    if(heart == "Online") {

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                retrieved = http.responseText;
                //console.log(retrieved);

            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+"&private="+type+
              "&info9="+index+"&info6="+publicname+"&info7="+sharing+"&action=update&type=PRIVACY" );


    }

}

function send_comment(theindex,statement) {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //var sending = file.split(":;:")[0];
    var retrieved;
   // console.log(url)

   // console.log(statement);

    var d = new Date();
    var thedate = d.getMonth()+1+"-"+d.getDate()+"-"+d.getFullYear();

    if(heart == "Online") {

    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                retrieved = http.responseText;
               // console.log(retrieved);
                    load_comments(listindex,theindex);
            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+"&comment="+statement+
              "&file="+username+":;:"+theindex+"&date="+thedate+"&action=sending&type=COMMENT" );


    }



}

function load_comments(listindex,theindex) {

   var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //var sending = file.split(":;:")[0];
    var retrieved;
    //console.log(url)

    console.log(theindex);



   // if(heart == "Online") {


    http.onreadystatechange = function() {

        if (http.readyState == 4) {

            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                comments.clear();
                retrieved = http.responseText;
             //  console.log(retrieved);
                var thecomments = retrieved.split(">!<");
                thelikes = thecomments[1].split(":;:")[0];
                //console.log(thecomments[0]);


                var currentliked;

                var testStr1 = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+theindex+"'";
                var testStr2 = "SELECT id FROM LIKES WHERE id ='"+theindex+"'";

                var data = [theindex,currentliked,thelikes];
               var insert = "INSERT INTO LIKES VALUES(?,?,?)";

                var updateyours = "UPDATE LIKES SET likes='"+thelikes+"' WHERE id='"+theindex+"'";


                db.transaction(function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)');

                   var youown = tx.executeSql(testStr1);
                   var alreadyliked = tx.executeSql(testStr2);


                    if(thecomments[0] == "2") {
                        postslist.remove(listindex);
                        var deletestring = "DELETE FROM STREAM WHERE picture_index ='"+theindex+"'";
                        tx.executeSql(deletestring);
                    }

                      if(alreadyliked.rows.length == 0) {

                            tx.executeSql(insert,data)

                          //console.log("Liking: "+index);
                        } else {
                          currentliked = alreadyliked.rows.item(0).liked;
                          tx.executeSql(updateyours);
                      }


                });



               // console.log(thecomments.length);
                if(thecomments.length > 1) {
                        pinfo = " ";
                } else {
                    pinfo = "No Comments";
                }

                var numofcomments = 2;
                while (thecomments.length > numofcomments) {
                   // console.log(thecomments[numofcomments]);
                    var coms = thecomments[numofcomments].split(":retrieved:");
                   // console.log(coms[0]);
                comments.append({
                name:coms[0].split(":;:")[0],
                comment:coms[1],
                date:coms[2],
                avatar:"graphics/avatar.png"



                });
                 numofcomments = numofcomments + 1;
                }

                commentnumber = numofcomments -2;
                //gc();
            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
              "&file="+theindex+"&action=comments&type=COMMENT" );


    //}



}

function likes(index,like,likes) {

    var http = new XMLHttpRequest();
     var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     //var sending = file.split(":;:")[0];
     var retrieved;
    // console.log(url)

     //console.log(theindex);

    var testStr1 = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+index+"'";
    var testStr2 = "SELECT id FROM LIKES WHERE id ='"+index+"'";

    var data = [index,like,likes];
   var insert = "INSERT INTO LIKES VALUES(?,?,?)";

    var updateyours = "UPDATE LIKES SET liked='"+like+"' WHERE id='"+theindex+"'";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)');

       var youown = tx.executeSql(testStr1);
       var alreadyliked = tx.executeSql(testStr2);

       if(youown.rows.length == 0) {

          if(alreadyliked.rows.length == 0) {

                tx.executeSql(insert,data)

              //console.log("Liking: "+index);
            } else {
              tx.executeSql(updateyours);
          }

       }


    });

     if(heart == "Online") {


     http.onreadystatechange = function() {

         if (http.readyState == 4) {

             if(http.responseText == 100) {
                 console.log("Incorrect DevID");
             } else if(http.responseText == 101) {
                 console.log("Incorrect AppID");
             } else {
                 retrieved = http.responseText;
                 //console.log(retrieved);
                // var thecomments = retrieved.split(">!<");
                 //console.log(thecomments.length);

             }

         }

     }
     http.open('POST', url.trim(), true);
    // console.log(http.statusText);
     //http.send(null);
     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
     http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
               "&file="+username+":;:"+theindex+"&date="+thedate+"&action=sending&type=LIKE" );

     }

}

function follow(account) {

    var http = new XMLHttpRequest();
     var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     //var sending = file.split(":;:")[0];
     var retrieved;
    // console.log(url)

     //console.log(theindex);

    var testStr1 = "SELECT name FROM USER WHERE name ='"+account+"'";
    var testStr2 = "SELECT os_account FROM FOLLOW WHERE os_account ='"+account+"'";

    var data = [account," ",account];
   var insert = "INSERT INTO FOLLOW VALUES(?,?,?)";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS FOLLOW (name TEXT,pin TEXT, os_account TEXT)');

       var youown = tx.executeSql(testStr1);
       var alreadyfollowed = tx.executeSql(testStr2);

       if(youown.rows.length == 0) {

          if(alreadyfollowed.rows.length == 0) {

                tx.executeSql(insert,data)

              //console.log("Liking: "+index);
            } else {
              var delStr = "DELETE FROM FOLLOW WHERE os_account ='"+account+"'";

                tx.executeSql(delStr);
                }

       }


    });

     if(heart == "Online") {


     http.onreadystatechange = function() {

         if (http.readyState == 4) {

             if(http.responseText == 100) {
                 console.log("Incorrect DevID");
             } else if(http.responseText == 101) {
                 console.log("Incorrect AppID");
             } else {
                 retrieved = http.responseText;
                 //console.log(retrieved);
                // var thecomments = retrieved.split(">!<");
                 //console.log(thecomments.length);

             }

         }

     }
     http.open('POST', url.trim(), true);
    // console.log(http.statusText);
     //http.send(null);
     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
     http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
               "&file="+account+"&date="+thedate+"&info11="+account+"&action=sending&type=FOLLOW" );

     }



}



function sendtouser (theindex,notes,sharetouser) {

    var http = new XMLHttpRequest();
     var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     var retrieved;

     if(heart == "Online") {


     http.onreadystatechange = function() {

         if (http.readyState == 4) {

             if(http.responseText == 100) {
                 console.log("Incorrect DevID");
             } else if(http.responseText == 101) {
                 console.log("Incorrect AppID");
             } else {
                 retrieved = http.responseText;
                 //console.log(retrieved);
                // var thecomments = retrieved.split(">!<");
                 //console.log(thecomments.length);

             }

         }

     }
     http.open('POST', url.trim(), true);
    // console.log(http.statusText);
     //http.send(null);
     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
         http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+sharetouser+
                   "&file="+username+":;:"+theindex+"&date="+thedate+"&action=sending&type=SHARE" );

     }



}



function silence(account) {

    var http = new XMLHttpRequest();
     var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     //var sending = file.split(":;:")[0];
     var retrieved;
    // console.log(url)

     //console.log(theindex);

    var testStr1 = "SELECT name FROM USER WHERE name ='"+account+"'";
    var testStr2 = "SELECT os_account FROM SILENCE WHERE os_account ='"+account+"'";

    var data = [account," ",account];
   var insert = "INSERT INTO SILENCE VALUES(?,?,?)";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS SILENCE (name TEXT,pin TEXT, os_account TEXT)');

       var youown = tx.executeSql(testStr1);
       var alreadyfollowed = tx.executeSql(testStr2);

       if(youown.rows.length == 0) {

          if(alreadyfollowed.rows.length == 0) {

                tx.executeSql(insert,data)

              //console.log("Liking: "+index);
            }

       }


    });

     if(heart == "Online") {


     http.onreadystatechange = function() {

         if (http.readyState == 4) {

             if(http.responseText == 100) {
                 console.log("Incorrect DevID");
             } else if(http.responseText == 101) {
                 console.log("Incorrect AppID");
             } else {
                 retrieved = http.responseText;
                 //console.log(retrieved);
                // var thecomments = retrieved.split(">!<");
                 //console.log(thecomments.length);

             }

         }

     }
     http.open('POST', url.trim(), true);
    // console.log(http.statusText);
     //http.send(null);
     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
     http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
               "&file="+account+"&date="+thedate+"&info11="+account+"&action=sending&type=SILENCE" );

     }



}

function report(account,image,reason) {

    var http = new XMLHttpRequest();
     var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     if(heart == "Online") {

     http.onreadystatechange = function() {

         if (http.readyState == 4) {

             if(http.responseText == 100) {
                 console.log("Incorrect DevID");
             } else if(http.responseText == 101) {
                 console.log("Incorrect AppID");
             } else {
                 retrieved = http.responseText;
                 //console.log(retrieved);
                // var thecomments = retrieved.split(">!<");
                 //console.log(thecomments.length);

             }

         }

     }
     http.open('POST', url.trim(), true);
    // console.log(http.statusText);
     //http.send(null);
     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
     http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
               "&file="+ account +":;:"+ image +"&date="+ thedate +"&comment="+ reason +"&action=sending&type=REPORT" );

     } else {
         progress.visible = true;
         progress.state  = "midScreen";
         info = "Currently Offline";
     }



}

function menu_notifications() {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";
   // console.log(url)

    http.onreadystatechange = function() {

       if(http.status == 200) {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

             var notes = http.responseText;

               // console.log(notes);

                var laststream = notes.split(":S:")[1].split(":L:")[0];
                var lastlibrary = notes.split(":L:")[1].split(":I:")[0];
                var lastinbox = notes.split(":I:")[1].split(":;:")[1];

                var LibraryStr = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+lastlibrary+"'";
                var StreamStr = "SELECT picture_index FROM STREAM WHERE picture_index ='"+laststream+"'";
                var InboxStr = "SELECT pin FROM SHARES WHERE pin ='"+lastinbox+"'"

                //console.log(lastinbox);

                db.transaction(function(tx) {

                     var libdex = tx.executeSql(LibraryStr);
                     var strdex = tx.executeSql(StreamStr);
                    var inboxdex = tx.executeSql(InboxStr);

                    if(libdex.rows.length == 0) {

                        themenu.newLibrary = 1;
                        if(whichview == 0 && library_syncing == 0) {
                            //if(whichview == 0) {
                        get_library.running = true;
                        }
                    } else {
                         console.log("nothing new in Library ");
                    }

                    if(strdex.rows.length == 0) {
                        themenu.newStream = 1;
                        if(whichview == 1 && stream_syncing == 0) {
                           // if(whichview == 1) {
                        get_stream.running = true;
                        }
                    } else {
                        console.log("nothing new in Stream");
                    }

                    if(inboxdex.rows.length == 0) {
                       // console.log(lastinbox);
                        if(stream_syncing == 0) {
                                console.log("Gathering");
                                gatherShares();
                                }
                    } else {
                         //console.log("nothing new in Inbox ");
                    }


                });

            }

        }
            } else {

        }
    }
    http.open('POST', url.trim(), true);

    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
              "&action=notify" );

}



function gatherShares() {

    var http = new XMLHttpRequest();
    var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";
   // console.log(url)

   // console.log("Gathering Shares");
    http.onreadystatechange = function() {

       if(http.status == 200) {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

             var notes = http.responseText;
                var num = 1;
                //console.log(notes);
                while(notes.split(">!<").length > num) {

                var sharer = notes.split(">!<")[num].split(":retrieved:")[1];
                   //console.log("TEST "+sharer);


                    var Sharers = "SELECT name FROM SHARES WHERE pin ='"+sharer.split(":;:")[1]+"'";
                    var addshare = "INSERT INTO SHARES VALUES(?,?,?)"
                    var data = [sharer.split(":;:")[0],sharer.split(":;:")[1],sharer.split(":;:")[0]];
                    var updateyours = "UPDATE SHARES SET pin='"+sharer.split(":;:")[1]+"' WHERE name='"+sharer.split(":;:")[0]+"'";

                    db.transaction(function(tx) {

                        var inshares = tx.executeSql(Sharers);


                         if(inshares.rows.length == 0) {
                                themenu.newShared = 1;
                            tx.executeSql(addshare,data);
                             retrievedata("SHARE",sharer.split(":;:")[1]);
                         }

                         /* else {
                             tx.executeSql(updateyours);
                            retrievedata("SHARE",sharer.split(":;:")[1]);
                         } */
                            //console.log(sharer.split(":;:")[1]);



                   });



                    num = num + 1;
                }



            }

        }

        }
    }

    http.open('POST', url.trim(), true);

    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+"&action=shared" );

}

function touchpic(url) {

    var http = new XMLHttpRequest();
    //var url = "https://openseed.vagueentertainment.com:8675/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";


    http.onreadystatechange = function() {

       if(http.status == 200) {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
              //console.log(http.responseText);


            }
        }
       }

    }
        http.open('GET',url.trim(), true);
        http.send(null);
        //http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        //http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
           //       "&action=notify" );

}



