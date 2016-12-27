var updateinterval = 2000;
var fullnumber = 0;

function oseed_auth(name,email) {

    var http = new XMLHttpRequest();
    //var url = "http://openseed.vagueentertainment.com/corescripts/auth.php?devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email ;
    var url = "http://openseed.vagueentertainment.com/corescripts/authPOST.php";
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
    http.send("devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email);

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


    });

   // reload.running = true;

    //get_stream.running = true;

    firstrun.running = true;


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
    var url = "http://openseed.vagueentertainment.com/corescripts/heartbeat.php";
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
                updateinterval = 2000;

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
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

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
              "&patreon="+patreon+"&type=IMAGE &action=sending" );

}



function retrievedata(type,serverhas) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //console.log("OpenSeed.js "+childname,account);
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


                    switch(type) {
                    case "IMAGE":store_img("Library",sitedata[stuffnum].split(":retrieved:")[0],
                                           sitedata[stuffnum].split(":retrieved:")[1],
                                           sitedata[stuffnum].split(":retrieved:")[4],
                                           sitedata[stuffnum].split(":retrieved:")[2],
                                           sitedata[stuffnum].split(":retrieved:")[3],
                                           sitedata[stuffnum].split(":retrieved:")[5],id,flattr,patreon);
                                         //   reload.running = true;
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
    }

}

function sync_library() {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";


    gc();

   // postslist.clear();

    imagequeue = " ";

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

                var testStr = "SELECT  *  FROM LIBRARY WHERE picture_index = '0' OR picture_index = '9999999'";

                var stuffStr = "SELECT  *  FROM LIBRARY WHERE 1"

                db.transaction(function(tx) {

                    tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');


                     var pull =  tx.executeSql(stuffStr);

                     var push = tx.executeSql(testStr);

                    var serverindex = 1;
                    var foundnew  = 0;
                    fetchedimage = 0;
                    //newimages = numonserver.split(">!<").length;

                    progress.visible = true;



                    if(push.rows.length > 0) {
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


                    }

                    while(numonserver.split(">!<").length > serverindex) {
                      // console.log(numonserver.split(">!<")[serverindex]);
                        var exists = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+numonserver.split(">!<")[serverindex]+"'";
                            var check = tx.executeSql(exists);
                        if(check.rows.length == 0) {
                            // retrievedata("IMAGE",numonserver.split(">!<")[serverindex]);
                            if(imagequeue == " ") {
                            imagequeue = numonserver.split(">!<")[serverindex];

                            } else {
                                imagequeue = imagequeue+","+numonserver.split(">!<")[serverindex];
                            }

                            foundnew = foundnew +1;
                        }

                        serverindex = serverindex + 1;
                    }



                    newimages = foundnew;

                    if(newimages == 0) {
                     //reload.running = true;
                        syncing = 0;
                     progress.visible = false;
                        beep.running = false;
                    } else {
                        info = "Syncing Library: ";
                        syncing = 1;
                        beep.running = true;
                        info = fetchedimage+"/"+newimages;
                        thefooter.state = "Hide";
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
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //console.log("OpenSeed.js "+childname,account);
    //console.log(url)

   // console.log("Search:"+search+"\nRating:"+not+"\nAnd Tags:"+tags);

    var type = "STREAM";



   // postslist.clear();

    fetchedimage = 0;


    imagequeue = " ";


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



              while(sitedata.length > stuffnum && stuffnum < 20) {



                  var exists = "SELECT picture_index FROM STREAM WHERE picture_index ='"+sitedata[stuffnum]+"'";
                      var check = tx.executeSql(exists);

                  if(check.rows.length == 0) {
                     // retrievedata("STREAM",sitedata[stuffnum]);
                      foundnew = foundnew +1;

                      if(imagequeue == " ") {
                      imagequeue = sitedata[stuffnum];

                      } else {
                          imagequeue = imagequeue+","+sitedata[stuffnum];
                      }


                  }


                stuffnum = stuffnum + 1;


            }



                });

                newimages = foundnew;

                if (newimages == 0) {
                    //stream_reload.running = true;
                    progress.visible = false;
                    syncing = 0;
                } else {
                    progress.state = "midscreen";
                     progress.visible = true;
                     syncing = 1;
                        info = "Updating Stream";
                    //console.log("Found new images: "+newimages);

                    boop.running = true;
                    info = fetchedimage+"/"+newimages;
                     thefooter.state = "Hide";
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

    switch(where) {
     case "Library": testStr = "SELECT * FROM LIBRARY WHERE picture_index ='"+picture_index+"'";
         thefile = paths.split(",")[2].trim()+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =file.split(":;:")[1].trim()+".jpg";
         data = [id,where,justfile,effect,comment,thedate,private,picture_index,base64];

                        break;
     case "Stream": testStr = "SELECT * FROM STREAM WHERE picture_index ='"+picture_index+"'";
         thefile = paths.split(",")[3].trim()+id+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO STREAM VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =id+file.split(":;:")[1].trim()+".jpg";
         data = [id+"::"+flattr+"::"+patreon,where,justfile,effect,comment,thedate,private,picture_index,base64];

                    break;

     default: testStr = "SELECT * FROM LIBRARY WHERE picture_index ='"+picture_index+"'";
         thefile = paths.split(",")[2].trim()+file.split(":;:")[1].trim()+".jpg"+":;:"+file.replace(/ /g,"+");
         insert = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?,?)";
         justfile =file.split(":;:")[1].trim()+".jpg";
         data = [id,where,justfile,effect,comment,thedate,private,picture_index,base64];

                        break;
    }




    var base64 = file.split(":;:")[0].replace(/ /g,"+");

    //var base64 = "na";



 try {
    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS STREAM (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

            var pull = tx.executeSql(testStr);

           // console.log(pull.rows.length);
            if(pull.rows.length == 0) {

               fileio.image = thefile;
                tx.executeSql(insert,data);
                fetchedimage = fetchedimage + 1;
                //console.log(fetchedimage+" adding "+justfile);
            }



    });
 } catch (err) {
        console.log("Error creating file: " + err);
 }

    //console.log(newimages+"/"+fetchedimage);


    if(newimages >= 61) {
        fullnumber = newimages;
        newimages = 60;

        info = fetchedimage+"/"+newimages+" (of "+fullnumber+")";

    } else {
        if(fullnumber == 0) {
        info = fetchedimage+"/"+newimages;
        } else {
            info = fetchedimage+"/"+newimages+" (of "+fullnumber+")";
        }
    }

    if(fetchedimage == 5) {
        progress.state = "minimal";
        switch(where) {
            case "Library":thefooter.state = "Show"; reload.running = true;break;
            case "Stream":thefooter.state = "Show"; stream_reload.running = true;break;
            default:thefooter.state = "Show"; reload.running = true;break;
        }

    }



    if(fetchedimage == newimages) {
        progress.state = "midscreen";
        syncing = 0;
    switch(where) {
    case "Library":thefooter.state = "Show"; reload.running = true;progress.visible = false;break;
    case "Stream":thefooter.state = "Show"; stream_reload.running = true;progress.visible = false;break;
    default:thefooter.state = "Show"; reload.running = true;progress.visible = false;break;
    }

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

function privacy_update(index,type) {

    var insert = "UPDATE LIBRARY SET private='"+type+"' WHERE picture_index='"+index+"'";
   db.transaction(function(tx) {

       tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (id TEXT,thedir TEXT,file TEXT,effect INT,comment TEXT,thedate TEXT,private INT,picture_index INT,base64 BLOB)');

          // var pull = tx.executeSql(testStr);

          // if(pull.rows.length != 0) {
            console.log("updating "+index);
           tx.executeSql(insert);

          // }
           //reload.running = true;
   });


    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

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
              "&info9="+index+"&action=update&type=PRIVACY" );


    }

}

function send_comment(theindex,statement) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

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

function load_comments(theindex) {

   var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

    //var sending = file.split(":;:")[0];
    var retrieved;
   // console.log(url)

    //console.log(theindex);

     comments.clear();

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
                var thecomments = retrieved.split(">!<");
                //console.log(thecomments.length);
                var numofcomments = 1;
                while (thecomments.length > numofcomments) {
                    var coms = thecomments[numofcomments].split(":retrieved:");
                    //console.log(coms);
                comments.append({
                name:coms[0].split(":;:")[0],
                comment:coms[1],
                date:coms[2],
                avatar:"graphics/avatar.png"



                });
                 numofcomments = numofcomments + 1;
                }
            }

        }

    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&username="+username+
              "&file="+theindex+"&action=comments&type=COMMENT" );


    }



}

function likes(index,like,likes) {



    var http = new XMLHttpRequest();
     var url = "http://openseed.vagueentertainment.com/devs/Vag-01001011/vagHeG-0630/scripts/sync.php";

     //var sending = file.split(":;:")[0];
     var retrieved;
    // console.log(url)

     //console.log(theindex);

    var testStr1 = "SELECT picture_index FROM LIBRARY WHERE picture_index ='"+index+"'";
    var testStr2 = "SELECT id FROM LIKES WHERE id ='"+index+"'";

    var data = [index,like,likes];
   var insert = "INSERT INTO LIKES VALUES(?,?,?)";

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS LIKES (id TEXT,liked INT,likes INT)');

       var youown = tx.executeSql(testStr1);
       var alreadyliked = tx.executeSql(testStr2);

       if(youown.rows.length == 0) {

          if(alreadyliked.rows.length == 0) {

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
                 var thecomments = retrieved.split(">!<");
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

