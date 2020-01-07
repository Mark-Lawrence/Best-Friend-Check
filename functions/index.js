const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.checkNotification = functions.database.ref('notification/{id}').onWrite(evt => {
	console.log("NOTIFICATION TRIGGERED");
	    //const name = admin.database().ref('notification/latestNotification');
    var db = admin.database();
    var ref = db.ref("notification/latestNotification");
    var name = 'Someone'
    var numberOfPushed = 0;
    ref.on("value", function(snapshot) {
        console.log("Reading new data from database:")
        console.log(snapshot.val());
        name = snapshot.val();
        numberOfPushed = numberOfPushed + 1;
        if (numberOfPushed === 1){
            var bodyString = name + ' has just sent a Best Friend Check!'
            if (name === "Everyone"){
                bodyString = "Everyone has checked in, Best Friend Check!"
            }
            console.log("Sending notification with name:")
            console.log(name);
            const payload = {
            notification:{
                title : 'Best Friend Check!',
                body : bodyString,
                badge : '0',
                sound : 'default',
                category : 'CustomSamplePush',
                'mutable-content' : '1'
                }
            };
            
            return admin.database().ref('fcm-token').once('value').then(allToken => {
                if(allToken.val()){
                    console.log('token available');
                    const token = Object.keys(allToken.val());
                    return admin.messaging().sendToDevice(token,payload);
                }else{
                    console.log('No token available');
                }
                return console.log('This is the notify feature');
            });
        }
    }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
    });
    
    

   
});

exports.addMessage = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
    const id = req.query.text;


    var d = new Date();
    var currentTime = d.getTime();
    
    if (id === "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2"){
        //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2", mark: true, justin: false, allison: false, nicole: false, ellie: false, molly: false)
        userName = "Mark"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: false,
            date: currentTime,
            ellie: false,
            justin: false,
            mark: true,
            molly: false,
            nicole: false,
            sender: id
        });
    } else if(id === "BZngmfcDMCZmxsX0HogN9bRSi1J2"){
       //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "BZngmfcDMCZmxsX0HogN9bRSi1J2", mark: false, justin: true, allison: false, nicole: false, ellie: false, molly: false)
        userName = "Justin"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: false,
            date: currentTime,
            ellie: false,
            justin: true,
            mark: false,
            molly: false,
            nicole: false,
            sender: id
        });
    } else if(id === "JHa5y5nuTPSwJWXqqc49OPSKFhl1"){
        //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "JHa5y5nuTPSwJWXqqc49OPSKFhl1", mark: false, justin: false, allison: true, nicole: false, ellie: false, molly: false)
        userName = "Allison"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: true,
            date: currentTime,
            ellie: false,
            justin: false,
            mark: false,
            molly: false,
            nicole: false,
            sender: id
        });
    } else if(id === "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2"){
        //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2", mark: false, justin: false, allison: false, nicole: true, ellie: false, molly: false)
        userName = "Nicole"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: false,
            date: currentTime,
            ellie: false,
            justin: false,
            mark: false,
            molly: false,
            nicole: true,
            sender: id
        });
    } else if(id === "lq90H5TV4Rf1cofy5nwyisfAZrs2"){
        //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "lq90H5TV4Rf1cofy5nwyisfAZrs2", mark: false, justin: false, allison: false, nicole: false, ellie: true, molly: false)
        userName = "Ellie"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: false,
            date: currentTime,
            ellie: true,
            justin: false,
            mark: false,
            molly: false,
            nicole: false,
            sender: id
        });
    } else if(id === "VCO1kUZIHjaQCziCcTDCPd83FNL2"){
        //bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "VCO1kUZIHjaQCziCcTDCPd83FNL2", mark: false, justin: false, allison: false, nicole: false, ellie: false, molly: true)
        userName = "Molly"
        admin.database().ref('best-friend-checks/new friend check').set({
            allison: false,
            date: currentTime,
            ellie: false,
            justin: false,
            mark: false,
            molly: true,
            nicole: false,
            sender: id
        });
    }
        
        //databaseRef = Database.database().reference()
        //databaseRef.child("notification/latestNotification").setValue(userName)
        
        //let bestFriendRef = self.bestFriendCheckRef.child("new friend check")
       // bestFriendRef.setValue(bestFriend.toAnyObject())
    
    
    //var userID = admin.uid;
    //admin.database().ref().child("notification/latestNotification").setValue(userName)
    
    admin.database().ref('notification').set({
        latestNotification: userName,
    });
    
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  //return admin.database().ref('/notification/latestNotification').push({latestNotification: userName}).then((snapshot) => {
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    //return res.redirect(303, snapshot.ref.toString());
  //});
});